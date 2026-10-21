import 'package:squadonsite/core/services/apple_auth_flow.dart';
import 'package:squadonsite/core/services/google_auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/auth/forgot_password_screen/forgot_password_controller.dart';
import 'package:squadonsite/auth/sign_up_screen/sign_up_controller.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/model/auth_model.dart';

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
  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await Get.find<ApiRepo>().login(
        LoginRequest(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
      if (response.accessToken.trim().isEmpty) {
        throw FormatException(
          "The server did not return a login token. Please try again.".tr,
        );
      }
      await Get.find<AuthSession>().update(response);
      Get.offAllNamed(AppRoutes.splashScreen);
    } catch (error) {
      AppSnackbar.show('sign_in_failed'.tr, _errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  String _errorMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  // ── Social ────────────────────────────────────────────────────────────────

  final RxBool isAppleLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  Future<void> handleAppleLogin() async {
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    isAppleLoading.value = true;
    try {
      await AppleAuthFlow.run();
    } finally {
      isAppleLoading.value = false;
    }
  }

  Future<void> handleGoogleLogin() async {
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    isGoogleLoading.value = true;
    try {
      await GoogleAuthFlow.run();
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void navigateToForgotPassword() => Get.toNamed(
    AppRoutes.forgotPasswordScreen,
    arguments: ForgotPasswordArgs.email(prefillEmail: ''),
  );

  void navigateToSignUp() =>
      Get.toNamed(AppRoutes.signUpScreen, arguments: SignUpArgs.email());

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
