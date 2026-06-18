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
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_binding.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_screen.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_binding.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/presentation/screens/splash_screen/splash_binding.dart';
import 'package:squadonsite/presentation/screens/splash_screen/splash_screen.dart';

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
  ];
}
