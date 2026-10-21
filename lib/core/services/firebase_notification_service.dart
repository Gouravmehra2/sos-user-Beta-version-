import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/notification_screen/notification_controller.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_details_screen.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_history_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseNotificationService.ensureFirebase();
  _logRemoteMessage(message, 'background');
}

void _logRemoteMessage(RemoteMessage message, String state) {
  if (!kDebugMode) return;

  final formattedMessage = const JsonEncoder.withIndent(
    '  ',
  ).convert(message.toMap());
  debugPrint(
    'FCM message received ($state):\n$formattedMessage',
    wrapWidth: 120,
  );
}

class _NotificationLifecycle extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(FirebaseNotificationService.onSessionReady());
      FirebaseNotificationService.refreshInbox();
      FirebaseNotificationService.onRouteReady();
    }
  }
}

class FirebaseNotificationService {
  static final _lifecycle = _NotificationLifecycle();
  static final _subscriptions = <StreamSubscription<dynamic>>[];
  static final _receivedIds = <String>{};
  static final _openedIds = <String>{};
  static Map<String, dynamic>? _pendingNavigation;
  static bool _navigating = false;
  static bool _routerReady = false;
  static io.Socket? _socket;
  static String _socketSession = '';
  static int _sessionGeneration = 0;

  static void refreshInbox() {
    if (Get.isRegistered<NotificationController>()) {
      unawaited(
        Get.find<NotificationController>().fetchNotifications(
          showLoading: false,
        ),
      );
    }
  }

  static void clearAccountState() {
    _sessionGeneration++;
    _socket?.dispose();
    _socket = null;
    _socketSession = '';
    _pendingNavigation = null;
    _routerReady = false;
    _receivedIds.clear();
    _openedIds.clear();
    if (_initialized) {
      unawaited(
        _localNotifications.cancelAll().catchError((Object error) {
          debugPrint('Unable to clear notifications: $error');
        }),
      );
    }
    if (Get.isRegistered<NotificationController>()) {
      final controller = Get.find<NotificationController>();
      controller.clearAccountState();
    }
  }

  static void _connectSocket(AuthSession session) {
    final userId = session.user?.id ?? '';
    if (userId.isEmpty) return;
    final key = '$userId:${session.accessToken}';
    if (_socketSession == key) return;
    _socket?.dispose();
    _socketSession = key;
    final origin = Uri.parse(
      ApiEndpoints.baseUrl,
    ).replace(path: '', query: null, fragment: null).toString();
    final socket = io.io(
      origin,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': session.accessToken})
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );
    _socket = socket;
    socket.onConnect((_) {
      socket.emit('user:join', userId);
      refreshInbox();
    });
    socket.on('notification:new', (_) => refreshInbox());
    socket.onConnectError((error) {
      final message = error.toString();
      if (message.contains('expired') ||
          message.contains('logged out') ||
          message.contains('Authentication required')) {
        socket.disconnect();
      }
    });
    socket.connect();
  }

  static void onRouteReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == AppRoutes.dashboardScreen) _routerReady = true;
      unawaited(_drainNavigation());
    });
  }

  static Future<void> _drainNavigation() async {
    if (_pendingNavigation == null ||
        _navigating ||
        !Get.isRegistered<AuthSession>() ||
        !Get.find<AuthSession>().hasToken ||
        Get.key.currentState == null ||
        !_routerReady) {
      return;
    }
    final data = _pendingNavigation!;
    _pendingNavigation = null;
    _navigating = true;
    final generation = _sessionGeneration;
    final account = Get.find<AuthSession>().accessToken;
    refreshInbox();
    try {
      final type = data['type']?.toString();
      final id = data['bookingId']?.toString() ?? '';
      if ((type == 'technician_assigned' || type == 'booking_status_updated') &&
          RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id)) {
        final response = await Get.find<DioClient>().get('/api/bookings/$id');
        final body = response.data;
        if (generation != _sessionGeneration ||
            Get.find<AuthSession>().accessToken != account) {
          return;
        }
        if (body is! Map ||
            body['success'] != true ||
            body['data'] is! Map ||
            body['data']['booking'] is! Map) {
          throw FormatException("Invalid booking response".tr);
        }
        final booking = BookingHistoryItem.fromJson(
          Map<String, dynamic>.from(body['data']['booking']),
        );
        Get.to(() => BookingDetailsScreen(booking: booking));
      } else {
        Get.toNamed(AppRoutes.notificationScreen);
      }
    } catch (_) {
      if (generation == _sessionGeneration &&
          Get.find<AuthSession>().accessToken == account) {
        Get.toNamed(AppRoutes.notificationScreen);
      }
    } finally {
      _navigating = false;
      if (_pendingNavigation != null) onRouteReady();
    }
  }

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static Future<void>? _initialization;
  static Future<FirebaseApp>? _firebaseInitialization;

  static Future<FirebaseApp> ensureFirebase() async {
    try {
      return await (_firebaseInitialization ??= _initializeFirebase());
    } catch (_) {
      _firebaseInitialization = null;
      rethrow;
    }
  }

  static Future<FirebaseApp> _initializeFirebase() async {
    if (Firebase.apps.isNotEmpty) return Firebase.app();
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<String?> getToken() async {
    try {
      await ensureFirebase();
      if (Platform.isIOS &&
          await FirebaseMessaging.instance.getAPNSToken() == null) {
        debugPrint('FCM registration waiting for the iOS APNs token.');
        return null;
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Unable to retrieve the Firebase messaging token: $error');
      }
      return null;
    }
  }

  static Future<void> initialize() async {
    try {
      await (_initialization ??= _initialize());
    } catch (_) {
      for (final subscription in _subscriptions) {
        await subscription.cancel();
      }
      _subscriptions.clear();
      WidgetsBinding.instance.removeObserver(_lifecycle);
      _initialized = false;
      _initialization = null;
      rethrow;
    }
  }

  static Future<void> _initialize() async {
    if (_initialized) return;

    await ensureFirebase();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _handlePayload(payload);
        }
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            'squadonsite_fcm_channel',
            "SquadOnSite Notifications".tr,
            description: "Notifications from the SquadOnSite app".tr,
            importance: Importance.max,
          ),
        );
    // iOS presents remote alerts natively. Android uses a local notification.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    _subscriptions.add(
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage),
    );
    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedAppMessage),
    );
    WidgetsBinding.instance.addObserver(_lifecycle);
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleOpenedAppMessage(initialMessage);
    final launch = await _localNotifications.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true) {
      _handlePayload(launch?.notificationResponse?.payload ?? '');
    }
    final permission = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      'Notification authorization: ${permission.authorizationStatus.name}',
    );
    _initialized = true;
    await onSessionReady();
  }

  static Future<void> onSessionReady() async {
    // Initialization connects the restored session if it finishes later.
    if (!_initialized || !Get.isRegistered<AuthSession>()) return;

    final session = Get.find<AuthSession>();
    if (!session.hasToken) return;

    _connectSocket(session);
    refreshInbox();
    onRouteReady();
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? 'New update';
    final body = message.notification?.body ?? 'You have a new notification';

    const androidDetails = AndroidNotificationDetails(
      'squadonsite_fcm_channel',
      'SquadOnSite Notifications',
      channelDescription: 'Notifications from the SquadOnSite app',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      presentBadge: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      details,
      payload: _payloadFromMessage(message),
    );
  }

  static bool _accept(RemoteMessage message, Set<String> seen) {
    if (message.data['target'] != null && message.data['target'] != 'user') {
      return false;
    }
    final id = message.messageId;
    if (id == null) return true;
    if (!seen.add(id)) return false;
    if (seen.length > 100) seen.remove(seen.first);
    return true;
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    _logRemoteMessage(message, 'foreground');
    if (!_accept(message, _receivedIds)) return;
    if (!Get.isRegistered<AuthSession>() || !Get.find<AuthSession>().hasToken) {
      return;
    }
    refreshInbox();
    // The system already presents iOS notification payloads, including taps.
    // Keep local display for Android and foreground data-only messages.
    if (Platform.isIOS && message.notification != null) return;
    unawaited(
      _showLocalNotification(message).catchError((Object error) {
        debugPrint('Unable to show notification: $error');
      }),
    );
  }

  static void _handleOpenedAppMessage(RemoteMessage message) {
    if (!_accept(message, _openedIds)) return;
    _handlePayload(_payloadFromMessage(message));
  }

  static void _handlePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return;
      final data = Map<String, dynamic>.from(decoded);
      if (data['target'] != null && data['target'] != 'user') return;
      _pendingNavigation = data;
      onRouteReady();
    } catch (_) {
      // Ignore malformed local payloads.
    }
  }

  static String _payloadFromMessage(RemoteMessage message) =>
      jsonEncode(message.data);

  static Future<void> dispose() async {
    clearAccountState();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    WidgetsBinding.instance.removeObserver(_lifecycle);
    _initialized = false;
    _initialization = null;
  }
}
