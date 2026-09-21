import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}