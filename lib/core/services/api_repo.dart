import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:squadonsite/core/services/firebase_notification_service.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/pagination/pagination_info.dart';
import 'package:squadonsite/model/auth_model.dart';
import 'package:squadonsite/model/apple_auth_model.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_history_model.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_invoice_model.dart';
import 'package:squadonsite/presentation/screens/notification_screen/model/notification_model.dart';

class ApiRepo {
  final DioClient dioClient;
  final Future<String?> Function() _getFcmToken;

  ApiRepo(this.dioClient, {Future<String?> Function()? getFcmToken})
    : _getFcmToken = getFcmToken ?? FirebaseNotificationService.getToken;

  Future<Map<String, dynamic>> _authPayload(Map<String, dynamic> data) async {
    String? token;
    try {
      token = (await _getFcmToken().timeout(
        const Duration(seconds: 10),
      ))?.trim();
      if (token?.isEmpty == true) token = null;
    } catch (error) {
      // Push availability must not prevent login or account creation.
      debugPrint('Unable to retrieve an FCM token for authentication: $error');
    }
    return {...data, 'fcmToken': ?token};
  }

  Future<AuthResponse> startRegister(RegisterRequest request) async {
    return _authResponse(
      await dioClient.post(
        ApiEndpoints.startRegister,
        data: await _authPayload(request.toJson()),
      ),
    );
  }

  Future<AuthResponse> verifyRegister(VerifyRegisterRequest request) async {
    return _authResponse(
      await dioClient.post(
        ApiEndpoints.verifyRegister,
        data: await _authPayload(request.toJson()),
      ),
    );
  }

  Future<AuthResponse> login(LoginRequest request) async {
    return _authResponse(
      await dioClient.post(
        ApiEndpoints.login,
        data: await _authPayload(request.toJson()),
      ),
    );
  }

  Future<AppleChallenge> appleChallenge() async {
    final response = await dioClient.post(
      ApiEndpoints.appleChallenge,
      data: {},
    );
    final body = response.data;
    if (body is! Map ||
        body['success'] != true ||
        body['nonce'] is! String ||
        (body['nonce'] as String).trim().isEmpty ||
        body['challengeToken'] is! String ||
        (body['challengeToken'] as String).trim().isEmpty) {
      throw FormatException(
        "Unable to start Apple sign-in. Please try again.".tr,
      );
    }
    return AppleChallenge(nonce: body['nonce'], token: body['challengeToken']);
  }

  Future<AppleLoginResult> appleLogin({
    required String identityToken,
    required String authorizationCode,
    required String challengeToken,
  }) async {
    if (identityToken.trim().isEmpty ||
        authorizationCode.trim().isEmpty ||
        challengeToken.trim().isEmpty) {
      throw ArgumentError(
        'Apple identity, authorization code and challenge tokens are required.',
      );
    }
    final response = await dioClient.post(
      ApiEndpoints.appleLogin,
      data: await _authPayload({
        'identityToken': identityToken,
        'authorizationCode': authorizationCode,
        'challengeToken': challengeToken,
      }),
    );
    final body = response.data;
    if (body is! Map || body['success'] != true) {
      throw FormatException("Unable to verify Apple sign-in.".tr);
    }
    if (body['requiresRegistration'] == true) {
      final token = body['appleRegistrationToken'];
      final data = body['data'];
      final email = data is Map ? data['email'] : null;
      if (token is! String ||
          token.trim().isEmpty ||
          email is! String ||
          email.trim().isEmpty) {
        throw FormatException("Apple registration details are incomplete.".tr);
      }
      return AppleLoginResult.registration(
        AppleRegistration(email: email, token: token),
      );
    }
    final session = _authResponse(response);
    if (session.accessToken.trim().isEmpty ||
        session.refreshToken.trim().isEmpty) {
      throw FormatException("The server did not return valid app tokens.".tr);
    }
    return AppleLoginResult.session(session);
  }

  Future<AuthResponse> googleLogin(String googleAccessToken) async {
    if (googleAccessToken.trim().isEmpty) {
      throw ArgumentError.value(
        googleAccessToken,
        'googleAccessToken',
        'must not be empty',
      );
    }
    final response = _authResponse(
      await dioClient.post(
        ApiEndpoints.googleLogin,
        data: await _authPayload({'accessToken': googleAccessToken.trim()}),
      ),
    );
    if (response.accessToken.trim().isEmpty ||
        response.refreshToken.trim().isEmpty) {
      throw FormatException(
        "The server did not return valid app tokens. Please try again.".tr,
      );
    }
    return response;
  }

  Future<({String name, String email})> googleSignup(
    String googleAccessToken,
  ) async {
    if (googleAccessToken.trim().isEmpty) {
      throw ArgumentError.value(
        googleAccessToken,
        'googleAccessToken',
        'must not be empty',
      );
    }
    final response = await dioClient.post(
      ApiEndpoints.googleSignup,
      data: {'accessToken': googleAccessToken.trim()},
    );
    final body = response.data;
    if (body is! Map<String, dynamic> || body['success'] == false) {
      throw FormatException(
        "Unable to verify Google signup. Please try again.".tr,
      );
    }
    final data = body['data'] is Map<String, dynamic>
        ? body['data'] as Map<String, dynamic>
        : body;
    final email = data['email'];
    final name = data['name'];
    if (email is! String ||
        email.trim().isEmpty ||
        (name != null && name is! String)) {
      throw FormatException(
        "The server did not return valid Google account details.".tr,
      );
    }
    return (name: (name as String?)?.trim() ?? '', email: email.trim());
  }

  Future<AuthResponse> me() async {
    return _authResponse(await dioClient.get(ApiEndpoints.me));
  }

  Future<HomeProfileResponse> meProfile() async {
    final response = await dioClient.get(ApiEndpoints.me);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid server response.".tr);
    }

    final result = HomeProfileResponse.fromJson(data);
    if (!result.success) {
      throw Exception('Unable to load profile details.');
    }
    return result;
  }

  /// Fetches the authenticated user's saved addresses from GET /api/auth/me.
  Future<List<UserAddress>> getAddresses() async {
    final response = await dioClient.get(ApiEndpoints.me);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid server response.".tr);
    }
    final profile = HomeProfileResponse.fromJson(data);
    return profile.data.user.addresses;
  }

  /// The backend's default-address operation uses the saved server ID.
  Future<void> updateSelectedAddress(UserAddress address) async {
    await setDefaultAddress(address.id);
  }

  Future<List<UserAddress>> setDefaultAddress(String id) async {
    final response = await dioClient.put(
      ApiEndpoints.updateMe,
      data: {'setDefaultAddress': id},
    );
    return _addressMutationResult(response);
  }

  List<UserAddress> _addressMutationResult(Response response) {
    final json = response.data;
    if (json is! Map<String, dynamic> || json['success'] != true) {
      throw FormatException("Could not save address.".tr);
    }
    final data = json['data'];
    if (data is! Map || data['user'] is! Map<String, dynamic>) {
      throw FormatException("Missing updated address list.".tr);
    }
    return HomeProfileResponse.fromJson(json).data.user.addresses;
  }

  /// Adds a brand-new address entry via PUT /api/auth/me.
  /// The backend appends it to the user's addresses array.
  Future<List<UserAddress>> addAddress({
    required String label,
    required String addressLine,
    required String city,
    required String state,
    required String zipcode,
    String name = '',
    bool isDefault = false,
    double? latitude,
    double? longitude,
    String? house,
    String? building,
    String? area,
    String? addressType,
  }) async {
    final response = await dioClient.put(
      ApiEndpoints.addAddress,
      data: {
        'addAddress': {
          'label': label,
          'name': name,
          'isDefault': isDefault,
          'addressLine': addressLine,
          'buildingFloor': house,
          'street': building,
          'city': city,
          'state': state,
          'zipcode': zipcode,
          if (latitude != null && longitude != null)
            'coordinates': {'lat': latitude, 'lng': longitude},
          'house': ?house,
          'building': ?building,
          'area': ?area,
          'addressType': ?addressType,
        },
      },
    );
    return _addressMutationResult(response);
  }

  /// Updates an existing address entry via PUT /api/auth/me.
  /// Sends the full address payload including the existing [id].
  Future<List<UserAddress>> updateAddress(UserAddress address) async {
    final response = await dioClient.put(
      ApiEndpoints.updateAddress,
      data: {
        'updateAddress': {
          'id': address.id,
          'label': address.label,
          'name': address.name,
          'addressLine': address.addressLine,
          'buildingFloor': address.house,
          'street': address.building,
          'city': address.city,
          'state': address.state,
          'zipcode': address.zipcode,
          if (address.latitude != null && address.longitude != null)
            'coordinates': {'lat': address.latitude, 'lng': address.longitude}
          else
            'coordinates': null,
          'house': ?address.house,
          'building': ?address.building,
          'area': ?address.area,
          'addressType': ?address.addressType,
        },
      },
    );
    return _addressMutationResult(response);
  }

  Future<void> removeAddress(String addressId) async {
    await dioClient.put(
      ApiEndpoints.updateMe,
      data: {'removeAddress': addressId},
    );
  }

  Future<SubcategoryResponse> getSubcategories(
    String categoryId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.subcategories(categoryId),
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    return SubcategoryResponse.fromJson(data, page: page, limit: limit);
  }

  Future<ServiceListResponse> getServicesBySubcategory(
    String subcategoryId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.servicesBySubcategory(subcategoryId),
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    return ServiceListResponse.fromJson(data, page: page, limit: limit);
  }

  Future<CreateBookingResponse> createBooking(Map<String, dynamic> body) async {
    debugPrint('');
    debugPrint('╔══════════════════════════════════════════════════════════╗');
    debugPrint('║  [BOOKING] ▶ POST ${ApiEndpoints.createBooking}');
    debugPrint('╠══════════════════════════════════════════════════════════╣');
    debugPrint('║  REQUEST PAYLOAD:');
    _prettyPrint(body);
    debugPrint('╚══════════════════════════════════════════════════════════╝');

    final response = await dioClient.post(
      ApiEndpoints.createBooking,
      data: body,
    );
    final data = response.data;

    debugPrint('');
    debugPrint('╔══════════════════════════════════════════════════════════╗');
    debugPrint('║  [BOOKING] ◀ RESPONSE  status: ${response.statusCode}');
    debugPrint('╠══════════════════════════════════════════════════════════╣');
    debugPrint('║  RESPONSE BODY:');
    _prettyPrint(data);
    debugPrint('╚══════════════════════════════════════════════════════════╝');

    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    return CreateBookingResponse.fromJson(data);
  }

  /// POST /bookings/verify
  ///
  /// Sends the payment attempt ID and the Stripe PaymentIntent ID.
  /// The backend independently verifies with Stripe that the payment
  /// succeeded and only then creates the Booking.
  ///
  /// Returns [VerifyBookingResponse] on 201.
  /// Throws [DioException] with statusCode 409 when payment is not yet
  /// complete — the caller must NOT clear the cart or show booking success.
  Future<VerifyBookingResponse> verifyBooking({
    required String paymentAttemptId,
    required String stripePaymentIntentId,
  }) async {
    final payload = {
      'paymentAttemptId': paymentAttemptId,
      'stripePaymentIntentId': stripePaymentIntentId,
    };

    debugPrint('');
    debugPrint('╔══════════════════════════════════════════════════════════╗');
    debugPrint('║  [VERIFY] ▶ POST ${ApiEndpoints.verifyBooking}');
    debugPrint('╠══════════════════════════════════════════════════════════╣');
    debugPrint('║  REQUEST PAYLOAD:');
    _prettyPrint(payload);
    debugPrint('╚══════════════════════════════════════════════════════════╝');

    final response = await dioClient.post(
      ApiEndpoints.verifyBooking,
      data: payload,
    );
    final data = response.data;

    debugPrint('');
    debugPrint('╔══════════════════════════════════════════════════════════╗');
    debugPrint('║  [VERIFY] ◀ RESPONSE  status: ${response.statusCode}');

    debugPrint('╠══════════════════════════════════════════════════════════╣');
    debugPrint('║  RESPONSE BODY:');
    _prettyPrint(data);
    debugPrint('╚══════════════════════════════════════════════════════════╝');

    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    return VerifyBookingResponse.fromJson(data);
  }

  void _prettyPrint(dynamic value, {int indent = 0}) {
    final pad = '  ' * indent;
    if (value is Map) {
      value.forEach((k, v) {
        if (v is Map || v is List) {
          debugPrint('$pad$k:');
          _prettyPrint(v, indent: indent + 1);
        } else {
          // Mask sensitive Stripe keys in logs
          final display = _maskSensitive(k.toString(), v);
          debugPrint('$pad$k: $display');
        }
      });
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        debugPrint('$pad[$i]:');
        _prettyPrint(value[i], indent: indent + 1);
      }
    } else {
      debugPrint('$pad$value');
    }
  }

  /// Masks the middle portion of secrets so they are readable in logs
  /// but not leakable (e.g. "sk_live_abc...xyz").
  String _maskSensitive(String key, dynamic value) {
    const sensitiveKeys = {
      'clientSecret',
      'publishableKey',
      'stripePaymentIntentId',
      'client_secret',
    };
    if (!sensitiveKeys.contains(key)) return '$value';
    final s = '$value';
    if (s.length <= 12) return '***';
    return '${s.substring(0, 6)}...${s.substring(s.length - 4)}';
  }

  Future<BookingHistoryResponse> getMyBookings({
    int page = 1,
    int limit = 10,
    String status = 'all',
    String search = '',
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.myBookings,
      queryParameters: {
        'page': page,
        'limit': limit,
        'status': status,
        if (search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    return BookingHistoryResponse.fromJson(data, page: page, limit: limit);
  }

  Future<Map<String, dynamic>> submitServiceReview({
    required String serviceId,
    required String bookingId,
    required int rating,
    required String review,
  }) async {
    final response = await dioClient.post(
      ApiEndpoints.serviceReviews(serviceId),
      data: {
        'bookingId': bookingId,
        'rating': rating,
        'review': review.trim().isEmpty
            ? 'No additional comments'
            : review.trim(),
      },
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid review response.".tr);
    }
    if (data['success'] != true) {
      final message = data['message'];
      throw Exception(
        message is String && message.isNotEmpty
            ? message
            : 'Unable to submit the service review.',
      );
    }
    return data;
  }

  Future<Map<String, dynamic>> submitTechnicianReview({
    required String bookingId,
    required int rating,
    required String review,
  }) async {
    final response = await dioClient.post(
      ApiEndpoints.technicianReview(bookingId),
      data: {
        'rating': rating,
        'review': review.trim().isEmpty
            ? 'No additional comments'
            : review.trim(),
      },
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid technician review response.".tr);
    }
    if (data['success'] != true) {
      final message = data['message'];
      throw Exception(
        message is String && message.isNotEmpty
            ? message
            : 'Unable to submit the technician review.',
      );
    }
    return data;
  }

  Future<BookingInvoice> getBookingInvoice(String bookingId) async {
    final response = await dioClient.get(
      ApiEndpoints.bookingInvoiceDetails(bookingId),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid invoice response.".tr);
    }
    if (data['success'] != true) {
      final message = data['message'];
      throw Exception(
        message is String && message.isNotEmpty
            ? message
            : 'Unable to load the invoice.',
      );
    }
    final payload = data['data'];
    final invoice = payload is Map<String, dynamic> ? payload['invoice'] : null;
    if (invoice is! Map<String, dynamic>) {
      throw FormatException("Invoice details are missing.".tr);
    }
    return BookingInvoice.fromJson(invoice);
  }

  Future<List<int>> downloadBookingInvoice({
    required String bookingId,
    required String downloadUrl,
  }) async {
    final expectedPath =
        '/api/bookings/${Uri.encodeComponent(bookingId)}/invoice';
    final baseUri = Uri.parse(ApiEndpoints.baseUrl);
    final providedUri = Uri.parse(downloadUrl);
    final invoiceUri = providedUri.hasScheme
        ? providedUri
        : baseUri.resolveUri(providedUri);
    if (!const ['http', 'https'].contains(invoiceUri.scheme) ||
        invoiceUri.origin != baseUri.origin ||
        invoiceUri.path != expectedPath) {
      throw FormatException("Invalid invoice download URL.".tr);
    }

    final response = await dioClient.get(
      invoiceUri.toString(),
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes is! List<int>) {
      throw FormatException("Invalid invoice download response.".tr);
    }
    return bytes;
  }

  Future<NotificationResponse> getNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid notifications response.".tr);
    }
    return NotificationResponse.fromJson(data, page: page, limit: limit);
  }

  Future<void> markAllNotificationsAsRead() async {
    await dioClient.patch(ApiEndpoints.readAllNotifications);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await dioClient.patch(ApiEndpoints.readNotification(notificationId));
  }

  Future<void> clearCart() async {
    await dioClient.delete(ApiEndpoints.clearCart);
  }

  Future<PaginatedItems<ServiceItem>> searchServices(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.searchServices(query),
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    final d = data['data'] as Map<String, dynamic>? ?? {};
    final list = d['services'] as List<dynamic>? ?? [];
    final services = list
        .map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedItems(
      items: services,
      hasMore: PaginationInfo.fromResponse(
        response: data,
        data: d,
        page: page,
        limit: limit,
        itemCount: services.length,
      ).hasMore,
    );
  }

  Future<PaginatedItems<FeaturedServiceItem>> getFeaturedServices({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.featuredServices,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid response.".tr);
    }
    final d = data['data'] as Map<String, dynamic>? ?? {};
    final list = d['services'] as List<dynamic>? ?? [];
    final services = list
        .map((e) => FeaturedServiceItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedItems(
      items: services,
      hasMore: PaginationInfo.fromResponse(
        response: data,
        data: d,
        page: page,
        limit: limit,
        itemCount: services.length,
      ).hasMore,
    );
  }

  AuthResponse _authResponse(Response response) {
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException("Invalid server response.".tr);
    }

    final result = AuthResponse.fromJson(data);
    if (!result.success) {
      throw Exception(
        result.message.isEmpty ? 'Request failed.' : result.message,
      );
    }
    return result;
  }
}
