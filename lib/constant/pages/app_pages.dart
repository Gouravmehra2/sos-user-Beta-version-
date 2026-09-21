import 'package:get/get.dart';
import 'package:squadonsite/auth/email_login_screen/email_login_binding.dart';
import 'package:squadonsite/auth/email_login_screen/email_login_screen.dart';
import 'package:squadonsite/auth/forgot_password_screen/forgot_password_binding.dart';
import 'package:squadonsite/auth/forgot_password_screen/forgot_password_screen.dart';
import 'package:squadonsite/auth/login_screen/login_binding.dart';
import 'package:squadonsite/auth/login_screen/login_screen.dart';
import 'package:squadonsite/auth/otp_screen/otp_binding.dart';
import 'package:squadonsite/auth/otp_screen/otp_screen.dart';
import 'package:squadonsite/auth/sign_up_screen/sign_up_binding.dart';
import 'package:squadonsite/auth/sign_up_screen/sign_up_screen.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/map_screen/map_binding.dart';
import 'package:squadonsite/presentation/screens/map_screen/map_screen.dart';
import 'package:squadonsite/presentation/screens/dashboard/dasboard_screen.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_binding.dart';
import 'package:squadonsite/presentation/screens/location_detail_screen/location_detail_binding.dart';
import 'package:squadonsite/presentation/screens/location_detail_screen/location_detail_screen.dart';
import 'package:squadonsite/presentation/screens/location_permission_screen/location_permission_bindings.dart';
import 'package:squadonsite/presentation/screens/location_permission_screen/location_permission_screen.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_binding.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_screen.dart';
import 'package:squadonsite/presentation/screens/personal_information_screen/personal_information_binding.dart';
import 'package:squadonsite/presentation/screens/personal_information_screen/personal_information_screen.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_binding.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:squadonsite/presentation/screens/booking_safety_screen/booking_safety_binding.dart';
import 'package:squadonsite/presentation/screens/booking_safety_screen/booking_safety_screen.dart';
import 'package:squadonsite/presentation/screens/security_screen/security_binding.dart';
import 'package:squadonsite/presentation/screens/security_screen/security_screen.dart';
import 'package:squadonsite/presentation/screens/support_screen/support_binding.dart';
import 'package:squadonsite/presentation/screens/support_screen/support_screen.dart';
import 'package:squadonsite/presentation/screens/support_screen/chat_support_binding.dart';
import 'package:squadonsite/presentation/screens/support_screen/chat_support_screen.dart';
import 'package:squadonsite/presentation/screens/support_screen/call_support_binding.dart';
import 'package:squadonsite/presentation/screens/support_screen/call_support_screen.dart';
import 'package:squadonsite/presentation/screens/support_screen/email_support_binding.dart';
import 'package:squadonsite/presentation/screens/support_screen/email_support_screen.dart';
import 'package:squadonsite/presentation/screens/support_screen/support_thank_you_screen.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_binding.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_screen.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_binding.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_screen.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_binding.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/presentation/screens/splash_screen/splash_binding.dart';
import 'package:squadonsite/presentation/screens/splash_screen/splash_screen.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_binding.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_screen.dart';
import 'package:squadonsite/presentation/screens/payment_screen/payment_binding.dart';
import 'package:squadonsite/presentation/screens/payment_screen/payment_screen.dart';
import 'package:squadonsite/presentation/screens/booking_confirmation_screen/booking_confirmation_screen.dart';
import 'package:squadonsite/presentation/screens/booking_status_screen/booking_status_binding.dart';
import 'package:squadonsite/presentation/screens/booking_status_screen/booking_status_screen.dart';
import 'package:squadonsite/presentation/screens/live_tracking_screen/live_tracking_binding.dart';
import 'package:squadonsite/presentation/screens/live_tracking_screen/live_tracking_screen.dart';
import 'package:squadonsite/presentation/screens/service_review_screen/service_review_binding.dart';
import 'package:squadonsite/presentation/screens/service_review_screen/service_review_screen.dart';
import 'package:squadonsite/presentation/screens/tip_technician_screen/tip_technician_binding.dart';
import 'package:squadonsite/presentation/screens/tip_technician_screen/tip_technician_screen.dart';
import 'package:squadonsite/presentation/screens/notification_screen/notification_binding.dart';
import 'package:squadonsite/presentation/screens/notification_screen/notification_screen.dart';
import 'package:squadonsite/presentation/screens/wallet_screen/wallet_binding.dart';
import 'package:squadonsite/presentation/screens/wallet_screen/wallet_screen.dart';
import 'package:squadonsite/presentation/screens/add_money_screen/add_money_binding.dart';
import 'package:squadonsite/presentation/screens/add_money_screen/add_money_screen.dart';
import 'package:squadonsite/presentation/screens/sos/sos_screen/sos_binding.dart';
import 'package:squadonsite/presentation/screens/sos/sos_screen/sos_screen.dart';
import 'package:squadonsite/presentation/screens/coupon screen/coupon_binding.dart';
import 'package:squadonsite/presentation/screens/coupon screen/coupon_screen.dart';
import 'package:squadonsite/presentation/screens/home_services_screen/home_services_binding.dart';
import 'package:squadonsite/presentation/screens/home_services_screen/home_services_screen.dart';

class AppPages {
  static List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.onboardingScreen,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.emailLoginScreen,
      page: () => const EmailLoginScreen(),
      binding: EmailLoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),GetPage(
      name: AppRoutes.locationPermissionScreen,
      page: () => const LocationPermissionScreen(),
      binding: LocationPermissionBindings(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.locationDetailScreen,
      page: () => const LocationDetailScreen(),
      binding: LocationDetailBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.dashboardScreen,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.mapScreen,
      page: () => const MapScreen(),
      binding: MapBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.selectLocationScreen,
      page: () => const SelectLocationScreen(),
      binding: SelectLocationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.personalInformationScreen,
      page: () => PersonalInformationScreen(),
      binding: PersonalInformationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.bookingSafetyScreen,
      page: () => const BookingSafetyScreen(),
      binding: BookingSafetyBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.supportScreen,
      page: () => const SupportScreen(),
      binding: SupportBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.chatSupportScreen,
      page: () => const ChatSupportScreen(),
      binding: ChatSupportBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.callSupportScreen,
      page: () => const CallSupportScreen(),
      binding: CallSupportBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.emailSupportScreen,
      page: () => const EmailSupportScreen(),
      binding: EmailSupportBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.supportThankYouScreen,
      page: () => const SupportThankYouScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.serviceScreen,
      page: () => const ServiceScreen(),
      binding: ServiceBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.bookServiceScreen,
      page: () => const BookServiceScreen(),
      binding: BookServiceBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.paymentOptionsScreen,
      page: () => const PaymentScreen(),
      binding: PaymentBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.bookingConfirmationScreen,
      page: () => const BookingConfirmationScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.bookingStatusScreen,
      page: () => const BookingStatusScreen(),
      binding: BookingStatusBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.liveTrackingScreen,
      page: () => const LiveTrackingScreen(),
      binding: LiveTrackingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.serviceReviewScreen,
      page: () => const ServiceReviewScreen(),
      binding: ServiceReviewBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.tipTechnicianScreen,
      page: () => const TipTechnicianScreen(),
      binding: TipTechnicianBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.securityScreen,
      page: () => const SecurityScreen(),
      binding: SecurityBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.walletScreen,
      page: () => const WalletScreen(),
      binding: WalletBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.addMoneyScreen,
      page: () => const AddMoneyScreen(),
      binding: AddMoneyBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.sosScreen,
      page: () => const SosScreen(),
      binding: SosBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.couponScreen,
      page: () => const CouponScreen(),
      binding: CouponBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.homeServicesScreen,
      page: () => const HomeServicesScreen(),
      binding: HomeServicesBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
