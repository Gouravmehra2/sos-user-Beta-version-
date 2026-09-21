import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';

class CallSupportController extends GetxController {
  void onCallNow() {
    Get.toNamed(AppRoutes.supportThankYouScreen, arguments: 'call');
  }

  void onLiveChat() {
    Get.toNamed(AppRoutes.chatSupportScreen);
  }

  void onEmailUs() {
    Get.toNamed(AppRoutes.emailSupportScreen);
  }
}
