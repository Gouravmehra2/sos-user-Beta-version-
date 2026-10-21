import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/sign_up_screen/sign_up_controller.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_country_code_picker.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/social_login_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) => _SignUpView(controller: controller),
    );
  }
}

class _SignUpView extends StatelessWidget {
  final SignUpController controller;

  const _SignUpView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Obx(
      () => PopScope(
        canPop: !controller.isLoading.value,
        child: Scaffold(
          backgroundColor: const Color(0xFFE8E8E8),
          body: Stack(
            children: [
              const _BackgroundPattern(),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 12,
                left: 18,
                child: IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.18),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              Positioned.fill(
                top: size.height * 0.225,
                child: _SignUpCard(controller: controller),
              ),
              if (controller.isLoading.value)
                const Positioned.fill(
                  child: Stack(
                    children: [
                      ModalBarrier(dismissible: false, color: Colors.black45),
                      Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundPattern extends StatelessWidget {
  const _BackgroundPattern();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.62,
        child: Stack(
          children: const [
            Positioned(
              top: 58,
              left: 16,
              child: Icon(Icons.key, size: 54, color: AppColor.blackColor),
            ),
            Positioned(
              top: 72,
              right: 26,
              child: Icon(
                Icons.home_work_outlined,
                size: 54,
                color: AppColor.blackColor,
              ),
            ),
            Positioned(
              top: 132,
              left: 154,
              child: Icon(
                Icons.favorite_border,
                size: 60,
                color: AppColor.blackColor,
              ),
            ),
            Positioned(
              top: 118,
              right: -10,
              child: Icon(
                Icons.handyman_outlined,
                size: 58,
                color: AppColor.blackColor,
              ),
            ),
            Positioned(
              bottom: 98,
              left: -12,
              child: Icon(
                Icons.construction_outlined,
                size: 62,
                color: AppColor.blackColor,
              ),
            ),
            Positioned(
              bottom: 54,
              right: 18,
              child: Icon(
                Icons.lightbulb_outline,
                size: 55,
                color: AppColor.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpCard extends StatelessWidget {
  final SignUpController controller;

  const _SignUpCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColor.blackColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'signup_title'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColor.blackShade1,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonCountryCodePicker(
                      height: 49,
                      onChanged: controller.onCountryChanged,
                      initialSelection:
                          controller.selectedCountry.value.code ?? 'US',
                      backgroundColor: Colors.white,
                      borderColor: AppColor.lightGreyColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CommonTextFormField(
                        controller: controller.phoneController,
                        hintText: 'login_hint_phone'.tr,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: controller.phoneFormatters,
                        validator: controller.validatePhone,
                        onChanged: controller.onPhoneChanged,
                        errorText: controller.phoneError.value.isEmpty
                            ? null
                            : controller.phoneError.value,
                        height: 49,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              CommonTextFormField(
                controller: controller.nameController,
                hintText: 'signup_hint_name'.tr,
                textInputAction: TextInputAction.next,
                validator: controller.nameValidator,
                height: 46,
              ),
              const SizedBox(height: 12),
              CommonTextFormField(
                controller: controller.emailController,
                hintText: 'signup_hint_email'.tr,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                enableSuggestions: false,
                validator: controller.emailValidator,
                height: 46,
              ),
              const SizedBox(height: 12),
              Obx(
                () => CommonTextFormField.password(
                  controller: controller.passwordController,
                  hintText: 'login_hint_password'.tr,
                  obscureText: !controller.isPasswordVisible.value,
                  onToggleObscure: controller.togglePasswordVisibility,
                  validator: controller.passwordValidator,
                  textInputAction: TextInputAction.next,
                  height: 46,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => CommonTextFormField.password(
                  controller: controller.confirmPasswordController,
                  hintText: 'signup_hint_confirm_password'.tr,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  onToggleObscure: controller.toggleConfirmPasswordVisibility,
                  validator: controller.confirmPasswordValidator,
                  textInputAction: TextInputAction.done,
                  height: 46,
                ),
              ),
              const SizedBox(height: 22),
              CommonButton(
                label: 'register'.tr,
                onTap: controller.handleContinue,
                height: 48,
                backgroundColor: Colors.black,
              ),
              const SizedBox(height: 14),
              const _DividerLabel(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => SocialLoginButton(
                        onTap: controller.handleAppleSignUp,
                        icon: Image.asset(AppAssets.appleImage, height: 20),
                        isLoading: controller.isAppleLoading.value,
                        enabled: !controller.isGoogleLoading.value,
                        height: 44,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => SocialLoginButton(
                        onTap: controller.handleGoogleSignUp,
                        icon: Image.asset(AppAssets.googleImage, height: 20),
                        isLoading: controller.isGoogleLoading.value,
                        enabled: !controller.isAppleLoading.value,
                        height: 44,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: controller.navigateToLogin,
                child: Text.rich(
                  TextSpan(
                    text: 'signup_have_account'.tr,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.coolGrayText,
                    ),
                    children: [
                      TextSpan(
                        text: "Log In".tr,
                        style: const TextStyle(
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE8E8E8))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or'.tr,
            style: const TextStyle(fontSize: 12, color: AppColor.coolGrayText),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE8E8E8))),
      ],
    );
  }
}
