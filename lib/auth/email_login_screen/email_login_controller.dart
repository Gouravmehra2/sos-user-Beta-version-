import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/forgot_password_screen/forgot_password_controller.dart';
import 'package:squadonsite/auth/otp_screen/otp_controller.dart';
import 'package:squadonsite/auth/sign_up_screen/sign_up_controller.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';

class EmailLoginController extends GetxController {
  // ── Controllers ───────────────────────────────────────────────────────────

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ── Form ──────────────────────────────────────────────────────────────────

  late GlobalKey<FormState> formKey;

  // ── Observables ───────────────────────────────────────────────────────────

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  // ── Password toggle ───────────────────────────────────────────────────────

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ── Validators ────────────────────────────────────────────────────────────

  FormFieldValidator<String> get emailValidator => CommonValidators.compose([
    CommonValidators.required(message: 'validation_email_required'.tr),
    CommonValidators.email(message: 'validation_email'.tr),
  ]);

  FormFieldValidator<String> get passwordValidator => CommonValidators.compose([
    CommonValidators.required(message: 'validation_password_required'.tr),
    CommonValidators.strongPassword(message: 'validation_password_strength'.tr),
  ]);

  // ── Login ─────────────────────────────────────────────────────────────────

  void handleLogin() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    // TODO: Call email login API — on success navigate to OTP verification
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.toNamed(
        AppRoutes.otpScreen,
        arguments: OtpArgs.email(email: emailController.text.trim()),
      );
    });
  }

  // ── Social ────────────────────────────────────────────────────────────────

  final _socialAuth = Get.find<SocialAuthService>();

  Future<void> handleAppleLogin() async {
    final result = await _socialAuth.signInWithApple();
    result.fold(
      onSuccess: (user) {
        // TODO: send user.idToken to your backend, then navigate
        debugPrint('[EmailLogin] Apple user: ${user.uid}');
      },
      onFailure: (msg) => Get.snackbar('sign_in_failed'.tr, msg),
      onCancelled: () {},
    );
  }

  Future<void> handleGoogleLogin() async {
    final result = await _socialAuth.signInWithGoogle();
    result.fold(
      onSuccess: (user) {
        // TODO: send user.idToken to your backend, then navigate
        debugPrint('[EmailLogin] Google user: ${user.email}');
      },
      onFailure: (msg) => Get.snackbar('sign_in_failed'.tr, msg),
      onCancelled: () {},
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void navigateToForgotPassword() => Get.toNamed(
    AppRoutes.forgotPasswordScreen,
    arguments: ForgotPasswordArgs.email(prefillEmail: ''),
  );

  void navigateToSignUp() => Get.toNamed(
        AppRoutes.signUpScreen,
        arguments: SignUpArgs.email(),
      );

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
