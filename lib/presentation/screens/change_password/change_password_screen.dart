import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        foregroundColor: Colors.white,
        title: Text(
          'change_password_title'.tr,
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'change_password_subtitle'.tr,
                  style: AppTextStyle.bodyMediumRegular.copyWith(
                    color: AppColor.coolGrayText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                Obx(
                  () => CommonTextFormField.password(
                    key: const ValueKey('old-password-field'),
                    controller: controller.oldPasswordController,
                    label: 'change_password_old_label'.tr,
                    hintText: 'change_password_old_hint'.tr,
                    obscureText: !controller.isOldPasswordVisible.value,
                    onToggleObscure: controller.toggleOldPasswordVisibility,
                    validator: controller.validateOldPassword,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CommonTextFormField.password(
                    key: const ValueKey('new-password-field'),
                    controller: controller.newPasswordController,
                    label: 'change_password_new_label'.tr,
                    hintText: 'change_password_new_hint'.tr,
                    obscureText: !controller.isNewPasswordVisible.value,
                    onToggleObscure: controller.toggleNewPasswordVisibility,
                    validator: controller.validateNewPassword,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CommonTextFormField.password(
                    key: const ValueKey('confirm-password-field'),
                    controller: controller.confirmPasswordController,
                    label: 'change_password_confirm_label'.tr,
                    hintText: 'change_password_confirm_hint'.tr,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    onToggleObscure: controller.toggleConfirmPasswordVisibility,
                    validator: controller.validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => CommonButton(
                    label: 'change_password_submit'.tr,
                    onTap: controller.submit,
                    isLoading: controller.isSubmitting.value,
                    enabled: !controller.isSubmitting.value,
                    height: 54,
                    borderRadius: 12,
                    backgroundColor: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
