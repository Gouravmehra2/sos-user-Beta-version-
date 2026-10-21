import 'package:squadonsite/core/services/google_auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';

class LoginBottomSheetController extends GetxController {
  final _socialAuth = Get.find<SocialAuthService>();

  final RxBool isAppleLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  Future<void> handleAppleLogin() async {
    if (isAppleLoading.value || isGoogleLoading.value) return;

    isAppleLoading.value = true;
    try {
      final result = await _socialAuth.signInWithApple();
      result.fold(
        onSuccess: (user) {
          // TODO: send user.idToken to your backend, then navigate
          debugPrint('[LoginBottomSheet] Apple user: ${user.uid}');
        },
        onFailure: (msg) => AppSnackbar.show('sign_in_failed'.tr, msg),
        onCancelled: () {},
      );
    } finally {
      isAppleLoading.value = false;
    }
  }

  Future<void> handleGoogleLogin() async {
    if (isAppleLoading.value || isGoogleLoading.value) return;

    isGoogleLoading.value = true;
    try {
      await GoogleAuthFlow.run();
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
