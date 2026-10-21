import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/reset_password_screen/reset_password_controller.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_auth_header.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      builder: (controller) => AuthLayout(
        imagePath: AppAssets.authBackgroundImage,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'reset_password_title'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blackShade1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'reset_password_subtitle'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.coolGrayText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Obx(
                    () => CommonTextFormField.password(
                      key: const ValueKey('reset-new-password'),
                      controller: controller.newPasswordController,
                      label: 'reset_password_new_label'.tr,
                      hintText: 'reset_password_new_hint'.tr,
                      obscureText: !controller.isNewPasswordVisible.value,
                      onToggleObscure: () =>
                          controller.isNewPasswordVisible.toggle(),
                      validator: controller.validateNewPassword,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CommonTextFormField.password(
                      key: const ValueKey('reset-confirm-password'),
                      controller: controller.confirmPasswordController,
                      label: 'reset_password_confirm_label'.tr,
                      hintText: 'reset_password_confirm_hint'.tr,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      onToggleObscure: () =>
                          controller.isConfirmPasswordVisible.toggle(),
                      validator: controller.validateConfirmPassword,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Obx(
                    () => CommonButton(
                      label: 'reset_password_submit'.tr,
                      onTap: controller.submit,
                      isLoading: controller.isLoading.value,
                      enabled: !controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
