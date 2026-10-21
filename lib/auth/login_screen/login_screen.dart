import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/login_screen/login_controller.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_auth_header.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_country_code_picker.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return AuthLayout(
          imagePath: AppAssets.authBackgroundImage,
          body: _LoginPanel(controller: controller),
        );
      },
    );
  }
}

class _LoginPanel extends StatelessWidget {
  final LoginController controller;

  const _LoginPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// Title
                Text(
                  'login_title'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackShade1,
                  ),
                ),
                const SizedBox(height: 10),


                /// Phone Number Row — rebuilds when country or live error changes
                Obx(() {
                  // Registering observables as Obx dependencies
                  controller.selectedCountry.value;
                  final phoneErr = controller.phoneError.value;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Country code picker
                      CommonCountryCodePicker(
                        onChanged: controller.onCountryChanged,
                        initialSelection:
                            controller.selectedCountry.value.code ?? 'IN',
                        backgroundColor: Colors.white,
                        borderColor: AppColor.lightGreyColor,
                      ),
                      const SizedBox(width: 10),

                      /// Phone number field — formatters + validator re-created
                      /// on every country change; errorText shows live feedback.
                      Expanded(
                        child: CommonTextFormField(
                          controller: controller.phoneController,
                          hintText: 'login_hint_phone'.tr,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: controller.phoneFormatters,
                          validator: controller.validatePhone,
                          onChanged: controller.onPhoneChanged,
                          errorText: phoneErr.isEmpty ? null : phoneErr,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 14),

                /// Password field
                Obx(
                  () => CommonTextFormField.password(
                    controller: controller.passwordController,
                    hintText: 'login_hint_password'.tr,
                    obscureText: !controller.isPasswordVisible.value,
                    onToggleObscure: controller.togglePasswordVisibility,
                    validator: CommonValidators.compose([
                      CommonValidators.required(
                        message: 'validation_password_required'.tr,
                      ),
                    ]),
                    textInputAction: TextInputAction.done,
                  ),
                ),

                /// Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.navigateToForgotPassword,
                    child: Text(
                      'login_forgot_password'.tr,
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                /// Sign In Button
                Obx(
                  () => CommonButton(
                    label: 'login_sign_in_btn'.tr,
                    onTap: controller.handleLogin,
                    isLoading: controller.isLoading.value,
                    enabled: !controller.isLoading.value,
                  ),
                ),
                const SizedBox(height: 16),

                /// OR divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColor.lightGreyColor,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'login_or_divider'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColor.coolGrayText,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColor.lightGreyColor,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Social login buttons
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => SocialLoginButton(
                          onTap: controller.handleAppleLogin,
                          icon: Image.asset(AppAssets.appleImage, height: 20),
                          isLoading: controller.isAppleLoading.value,
                          enabled: !controller.isGoogleLoading.value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Obx(
                        () => SocialLoginButton(
                          onTap: controller.handleGoogleLogin,
                          icon: Image.asset(AppAssets.googleImage, height: 20),
                          isLoading: controller.isGoogleLoading.value,
                          enabled: !controller.isAppleLoading.value,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Sign Up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'login_no_account'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.coolGrayText,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.navigateToSignUp,
                      child: Text(
                        'login_sign_up_link'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
