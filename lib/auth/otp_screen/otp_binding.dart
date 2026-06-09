import 'package:get/get.dart';
import 'package:squadonsite/auth/otp_screen/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
