import 'package:get/get.dart';
import 'package:squadonsite/auth/reset_password_screen/reset_password_controller.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController());
  }
}
