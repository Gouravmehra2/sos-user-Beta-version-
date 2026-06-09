import 'package:get/get.dart';
import 'package:squadonsite/auth/login_screen/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
