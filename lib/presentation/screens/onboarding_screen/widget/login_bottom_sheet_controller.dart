import 'package:squadonsite/core/services/apple_auth_flow.dart';
import 'package:squadonsite/core/services/google_auth_flow.dart';
import 'package:get/get.dart';

class LoginBottomSheetController extends GetxController {
  final RxBool isAppleLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  Future<void> handleAppleLogin() async {
    if (isAppleLoading.value || isGoogleLoading.value) return;

    isAppleLoading.value = true;
    try {
      await AppleAuthFlow.run();
    } finally {
      isAppleLoading.value = false;
    }
  }

  Future<void> handleGoogleLogin() async {
    if (isAppleLoading.value || isGoogleLoading.value) return;

    isGoogleLoading.value = true;
    try {
      await GoogleAuthFlow.run(signupIfAccountMissing: true);
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
