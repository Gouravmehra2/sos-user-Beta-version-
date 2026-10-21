import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/password_reset_api.dart';

class ResetPasswordArgs {
  const ResetPasswordArgs({
    required this.api,
    required this.phone,
    required this.otp,
  });

  final PasswordResetApi api;
  final String phone;
  final String otp;
}

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  ResetPasswordArgs? args;

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'reset_password_required'.tr;
    if (value.length < 6) return 'reset_password_min_length'.tr;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'reset_password_confirm_required'.tr;
    }
    if (value != newPasswordController.text) {
      return 'reset_password_mismatch'.tr;
    }
    return null;
  }

  Future<void> submit() async {
    if (isLoading.value || !formKey.currentState!.validate()) return;
    final resetArgs = args;
    if (resetArgs == null) {
      AppSnackbar.show('reset_password_title'.tr, 'reset_session_expired'.tr);
      Get.offAllNamed(AppRoutes.loginScreen);
      return;
    }

    isLoading.value = true;
    var didReset = false;
    try {
      final response = await resetArgs.api.resetPassword(
        phone: resetArgs.phone,
        otp: resetArgs.otp,
        newPassword: newPasswordController.text,
      );
      newPasswordController.clear();
      confirmPasswordController.clear();
      final message = response['message'];
      AppSnackbar.show(
        'reset_password_title'.tr,
        message is String && message.isNotEmpty
            ? message
            : 'reset_password_success'.tr,
      );
      didReset = true;
    } on ResetApiException catch (error) {
      AppSnackbar.show('reset_password_title'.tr, error.message);
    } on TimeoutException {
      AppSnackbar.show('reset_password_title'.tr, 'reset_password_timeout'.tr);
    } on SocketException {
      AppSnackbar.show('reset_password_title'.tr, 'network_retry'.tr);
    } on http.ClientException {
      AppSnackbar.show('reset_password_title'.tr, 'network_retry'.tr);
    } finally {
      isLoading.value = false;
      if (didReset) Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  void onInit() {
    super.onInit();
    final routeArgs = Get.arguments;
    args = routeArgs is ResetPasswordArgs ? routeArgs : null;
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
