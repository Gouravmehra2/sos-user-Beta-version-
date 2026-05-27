import 'package:get/get.dart';
import 'package:squadonsite/core/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/dashboard/dasboard_screen.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_binding.dart';
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
      name: AppRoutes.dashboardScreen,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
