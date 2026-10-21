import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'model/change_password_request.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isSubmitting = false.obs;

  String? validateOldPassword(String? value) => CommonValidators.required(
    message: 'change_password_old_required'.tr,
  )(value);

  String? validateNewPassword(String? value) => CommonValidators.compose([
    CommonValidators.required(message: 'change_password_new_required'.tr),
    CommonValidators.strongPassword(message: 'validation_password_strength'.tr),
  ])(value);

  String? validateConfirmPassword(String? value) => CommonValidators.compose([
    CommonValidators.required(message: 'change_password_confirm_required'.tr),
    CommonValidators.match(
      () => newPasswordController.text,
      message: 'change_password_mismatch'.tr,
    ),
  ])(value);

  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> submit() async {
    if (isSubmitting.value || !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting.value = true;
    try {
      final response = await Get.find<DioClient>().put(
        ApiEndpoints.changePassword,
        data: ChangePasswordRequest(
          oldPassword: oldPasswordController.text,
          newPassword: newPasswordController.text,
        ).toJson(),
      );
      final body = response.data;
      if (body is Map && body['success'] == false) {
        throw ApiException(
          message: body['message']?.toString() ?? 'change_password_failed'.tr,
        );
      }

      Get.back<void>();
      AppSnackbar.show('Success', 'change_password_success'.tr);
    } catch (error) {
      final message = error is ApiException
          ? error.message
          : 'change_password_failed'.tr;
      AppSnackbar.show('Request failed', message);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
