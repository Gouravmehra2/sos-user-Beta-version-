import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/technician_home_screen/technician_home_controller.dart';

class TechnicianHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicianHomeController>(() => TechnicianHomeController());
  }
}
