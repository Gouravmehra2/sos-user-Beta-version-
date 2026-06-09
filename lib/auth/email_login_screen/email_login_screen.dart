import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/email_login_screen/email_login_controller.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_auth_header.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/common_widgets/social_login_button.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailLoginController>(
      builder: (controller) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: MyScaffold(
            useSafeArea: true,
            backgroundColor: AppColor.blackShade2,
            body: AuthLayout(
              imagePath: AppAssets.personImage,
              body: _EmailLoginPanel(controller: controller),
            ),
          ),
        );
      },
    );
  }
}

// ─── Panel ────────────────────────────────────────────────────────────────────

class _EmailLoginPanel extends StatelessWidget {
  final EmailLoginController controller;

  const _EmailLoginPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.648,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ── Title ──────────────────────────────────────────────────
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackShade1,
                  ),
                ),
                const SizedBox(height: 6),

                // ── Subtitle ───────────────────────────────────────────────
                const Text(
                  'Enter your details to continue\nwith Squad On Site',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.coolGrayText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Email field ────────────────────────────────────────────
                CommonTextFormField(
                  controller: controller.emailController,
                  hintText: 'Enter your Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: controller.emailValidator,
                ),
                const SizedBox(height: 14),

                // ── Password field ─────────────────────────────────────────
                Obx(
                  () => CommonTextFormField.password(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    obscureText: !controller.isPasswordVisible.value,
                    onToggleObscure: controller.togglePasswordVisibility,
                    validator: controller.passwordValidator,
                    textInputAction: TextInputAction.done,
                  ),
                ),

                // ── Forgot Password ────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.navigateToForgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColor.brownAccentPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // ── Sign In button ─────────────────────────────────────────
                Obx(
                  () => CommonButton(
                    label: 'Sign In',
                    onTap: controller.handleLogin,
                    isLoading: controller.isLoading.value,
                  ),
                ),
                const SizedBox(height: 16),

                // ── OR divider ─────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                          color: AppColor.lightGreyColor, thickness: 1),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                            fontSize: 13, color: AppColor.coolGrayText),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                          color: AppColor.lightGreyColor, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Social buttons ─────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SocialLoginButton(
                        onTap: controller.handleAppleLogin,
                        icon: Image.asset(AppAssets.appleImage,height: 20,),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SocialLoginButton(
                        onTap: controller.handleGoogleLogin,
                        icon:Image.asset(AppAssets.googleImage,height: 20,)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Sign Up link ───────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          fontSize: 13, color: AppColor.coolGrayText),
                    ),
                    GestureDetector(
                      onTap: controller.navigateToSignUp,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColor.brownAccentPrimary,
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

