class ApiEndpoints {
  ApiEndpoints._();

  /// Backend API endpoint for HTTP services, password reset, and Places.
  /// Production: --dart-define=API_BASE_URL=https://your-host/api

  //LOCAL URL
  // static const String apiBaseUrl = String.fromEnvironment(
  //   'API_BASE_URL',
  //   defaultValue: 'http://192.168.1.41:5001/api',
  // );

  // LIVE URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://1oneapp.com/api',
  );

  /// All existing /api/... routes and sockets share the configured origin.
  static final String baseUrl = Uri.parse(
    apiBaseUrl,
  ).replace(path: '', query: null, fragment: null).toString();

  static const String imageUrl = 'https://1appweb.s3.us-west-1.amazonaws.com/';

  static const String startRegister = '/api/auth/start-register';
  static const String verifyRegister = '/api/auth/verify-register';
  static const String googleLogin = '/api/auth/google';
  static const String appleChallenge = '/api/auth/apple/challenge';
  static const String appleLogin = '/api/auth/apple';
  static const String googleSignup = '/api/auth/google-signup';
  static const String login = '/api/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resendPasswordResetOtp = '/auth/resend-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/api/auth/logout';
  static const String changePassword = '/api/auth/change-password';
  static const String me = '/api/auth/me';
  static const String updateMe = '/api/auth/me';
  static const String uploadProfileImage = '/api/auth/me/avatar';
  static const String addAddress = '/api/auth/me';
  static const String updateAddress = '/api/auth/me';

  static String subcategories(String categoryId) =>
      '/api/services/categories/$categoryId/subcategories';

  static String servicesBySubcategory(String subcategoryId) =>
      '/api/services/subcategories/$subcategoryId/services';

  static const String createBooking = '/api/bookings';
  static const String myBookings = '/api/bookings/my-bookings';
  static const String verifyBooking = '/api/bookings/verify';
  static String bookingInvoiceDetails(String bookingId) =>
      '/api/bookings/${Uri.encodeComponent(bookingId)}/invoice/details';
  static String serviceReviews(String serviceId) =>
      '/api/services/${Uri.encodeComponent(serviceId)}/reviews';
  static String technicianReview(String bookingId) =>
      '/api/bookings/${Uri.encodeComponent(bookingId)}/technician-review';
  static const String clearCart = '/api/cart';
  static const String plans = '/api/plans';
  static const String planPurchases = '/api/plans/purchases';
  static const String verifyPlanPurchase = '/api/plans/purchases/verify';
  static const String myPlanPurchases = '/api/plans/my-purchases';

  static String chatMessages(String userId) =>
      '/api/chat/conversations/user/$userId/messages';

  static String chatRead(String userId) =>
      '/api/chat/conversations/user/$userId/read';

  static String searchServices(String query) =>
      '/api/services?status=active&search=${Uri.encodeComponent(query)}';

  static const String featuredServices = '/api/services/featured';

  static const String notifications = '/api/notifications';
  static const String readAllNotifications = '/api/notifications/read-all';

  static String readNotification(String notificationId) =>
      '/api/notifications/${Uri.encodeComponent(notificationId)}/read';
}
