import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/security_screen/security_controller.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SecurityController());
  }
}