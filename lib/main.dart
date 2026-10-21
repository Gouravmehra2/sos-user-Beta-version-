import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/startup/startup_tasks.dart';
import 'package:squadonsite/constant/pages/app_pages.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/services/chat_socket_service.dart';
import 'package:squadonsite/core/services/firebase_notification_service.dart';
import 'package:squadonsite/core/services/language_service.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';
import 'package:squadonsite/translations/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseNotificationService.ensureFirebase();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  handleDeviceOrientation();
  final languageService = LanguageService();
  await languageService.initialize();
  Get.put(languageService, permanent: true);
  _registerServices();
  runApp(const MyApp());
}

final _startupTasks = StartupTasks(
  initializeNotifications: FirebaseNotificationService.initialize,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        defaultTransition: Platform.isIOS
            ? Transition.cupertino
            : Transition.native,
        transitionDuration: const Duration(milliseconds: 250),
        getPages: AppPages.getPages,
        initialRoute: AppRoutes.splashScreen,
        routingCallback: (routing) {
          FirebaseNotificationService.onRouteReady();
          final route = routing?.current;
          if (route != null &&
              route.isNotEmpty &&
              route != AppRoutes.splashScreen) {
            _startupTasks.schedule();
          }
        },
        debugShowCheckedModeBanner: false,
        builder: (context, child) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child ?? const SizedBox.shrink(),
        ),
        theme: ThemeData(
          fontFamily: 'Inter',
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF111111),
            onPrimary: Colors.white,
            secondary: Color(0xFF3C3C3C),
            onSecondary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF1E1E1E),
            error: Colors.red,
            onError: Colors.white,
            outline: Color(0xFFEAEAEA),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111111),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Color(0xFF111111)),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF111111),
              side: BorderSide(color: Color(0xFF111111)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEAEAEA)),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF111111), width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xFF111111),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? const Color(0xFF111111)
                  : Colors.transparent,
            ),
            checkColor: WidgetStateProperty.all(Colors.white),
          ),
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? const Color(0xFF111111)
                  : const Color(0xFFEAEAEA),
            ),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? const Color(0xFF111111)
                  : Colors.white,
            ),
            trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? const Color(0xFF555555)
                  : const Color(0xFFEAEAEA),
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFFEAEAEA),
            thickness: 1,
          ),
        ),
        // ── Localisation ──────────────────────────────────────────────────────
        translations: AppTranslations(),
        supportedLocales: LanguageService.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        locale: Get.find<LanguageService>().locale,
        fallbackLocale: const Locale('en', 'US'),
      ),
    );
  }
}

void handleDeviceOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

void _registerServices() {
  Get.put(DioClient(), permanent: true);
  Get.lazyPut(() => SocialAuthService(), fenix: true);
  Get.put(ApiRepo(Get.find<DioClient>()), permanent: true);
  Get.put(AuthSession(), permanent: true);
  Get.put(ChatSocketService(), permanent: true);
}
