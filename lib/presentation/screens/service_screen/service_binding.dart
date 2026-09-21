import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_controller.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceController());
  }
}
