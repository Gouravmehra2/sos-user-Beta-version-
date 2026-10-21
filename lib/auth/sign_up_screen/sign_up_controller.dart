import 'package:squadonsite/core/services/apple_auth_flow.dart';
import 'package:squadonsite/model/apple_auth_model.dart';
import 'package:squadonsite/model/google_signup_details.dart';
import 'package:flutter/foundation.dart';
import 'package:squadonsite/core/services/google_auth_flow.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/auth/otp_screen/otp_controller.dart';
import 'package:squadonsite/auth/sign_up_screen/model/sign_up_screen_model.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';

// ── Mode ──────────────────────────────────────────────────────────────────────

enum SignUpMode { phone, email }

// ── Args ─────────────────────────────────────────────────────────────────────

/// Default (phone flow):
/// ```dart
/// Get.toNamed(AppRoutes.signUpScreen);
/// ```
///
/// From email login screen:
/// ```dart
/// Get.toNamed(AppRoutes.signUpScreen, arguments: SignUpArgs.email());
/// ```
class SignUpArgs {
  final SignUpMode mode;

  const SignUpArgs._({required this.mode});

  factory SignUpArgs.phone() => const SignUpArgs._(mode: SignUpMode.phone);
  factory SignUpArgs.email() => const SignUpArgs._(mode: SignUpMode.email);
}

// ── Per-country digit lengths ─────────────────────────────────────────────────

const Map<String, ({int min, int max})> _countryDigitLengths = {
  'IN': (min: 10, max: 10),
  'US': (min: 10, max: 10),
  'CA': (min: 10, max: 10),
  'GB': (min: 10, max: 11),
  'AU': (min: 9, max: 9),
  'AE': (min: 9, max: 9),
  'SA': (min: 9, max: 9),
  'PK': (min: 10, max: 10),
  'BD': (min: 10, max: 10),
  'NG': (min: 10, max: 10),
  'CN': (min: 11, max: 11),
  'JP': (min: 10, max: 11),
  'DE': (min: 10, max: 11),
  'FR': (min: 10, max: 10),
  'BR': (min: 10, max: 11),
  'MX': (min: 10, max: 10),
  'ZA': (min: 9, max: 9),
  'KE': (min: 9, max: 9),
  'EG': (min: 10, max: 10),
  'IT': (min: 9, max: 10),
  'ES': (min: 9, max: 9),
  'RU': (min: 10, max: 10),
  'TR': (min: 10, max: 10),
  'ID': (min: 9, max: 12),
  'PH': (min: 10, max: 10),
  'TH': (min: 9, max: 9),
  'VN': (min: 9, max: 10),
  'MY': (min: 9, max: 10),
  'SG': (min: 8, max: 8),
  'NZ': (min: 8, max: 9),
  'AR': (min: 10, max: 10),
  'CO': (min: 10, max: 10),
  'CL': (min: 9, max: 9),
  'GH': (min: 9, max: 9),
  'ET': (min: 9, max: 9),
  'TZ': (min: 9, max: 9),
  'UG': (min: 9, max: 9),
  'IQ': (min: 10, max: 10),
  'IR': (min: 10, max: 10),
  'MA': (min: 9, max: 9),
  'DZ': (min: 9, max: 9),
  'SD': (min: 9, max: 9),
  'UA': (min: 9, max: 9),
  'PL': (min: 9, max: 9),
  'NL': (min: 9, max: 9),
  'BE': (min: 8, max: 9),
  'SE': (min: 9, max: 10),
  'NO': (min: 8, max: 8),
  'DK': (min: 8, max: 8),
  'FI': (min: 9, max: 10),
  'PT': (min: 9, max: 9),
  'CH': (min: 9, max: 9),
  'AT': (min: 10, max: 11),
  'CZ': (min: 9, max: 9),
  'RO': (min: 9, max: 9),
  'HU': (min: 9, max: 9),
  'GR': (min: 10, max: 10),
  'IL': (min: 9, max: 9),
  'KW': (min: 8, max: 8),
  'QA': (min: 8, max: 8),
  'BH': (min: 8, max: 8),
  'JO': (min: 9, max: 9),
  'LB': (min: 8, max: 8),
  'LK': (min: 9, max: 9),
  'NP': (min: 10, max: 10),
  'MM': (min: 9, max: 10),
  'KH': (min: 8, max: 9),
  'KZ': (min: 10, max: 10),
};

// ── Controller ────────────────────────────────────────────────────────────────

class SignUpController extends GetxController {
  AppleRegistration? _appleRegistration;
  String? _googleEmail;

  void _applyAppleRegistration(AppleRegistration registration) {
    _googleEmail = null;
    _appleRegistration = registration;
    if (registration.name.isNotEmpty) nameController.text = registration.name;
    emailController.text = registration.email;
  }

  void _restoreProviderEmail() {
    final email = _appleRegistration?.email ?? _googleEmail;
    if (email != null && emailController.text != email) {
      emailController.text = email;
    }
  }
  // ── Mode ──────────────────────────────────────────────────────────────────

  late SignUpMode mode;

  bool get isEmailMode => mode == SignUpMode.email;

  String get subtitleText =>
      isEmailMode ? 'signup_subtitle_email'.tr : 'signup_subtitle_phone'.tr;

  // ── Controllers ───────────────────────────────────────────────────────────

  /// Used in phone mode.
  final TextEditingController phoneController = TextEditingController();

  /// Used in email mode.
  final TextEditingController emailController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  // ── Form ──────────────────────────────────────────────────────────────────

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Phone-only ────────────────────────────────────────────────────────────

  final RxString phoneError = ''.obs;

  final Rx<CountryCode> selectedCountry = CountryCode(
    code: 'US',
    dialCode: '+1',
    name: 'United States',
  ).obs;

  ({int min, int max}) get _digitLengths {
    final code = selectedCountry.value.code?.toUpperCase() ?? '';
    return _countryDigitLengths[code] ?? (min: 6, max: 15);
  }

  List<TextInputFormatter> get phoneFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(_digitLengths.max),
  ];

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_phone_required'.tr;
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final lengths = _digitLengths;
    if (digits.length < lengths.min || digits.length > lengths.max) {
      final rangeText = lengths.min == lengths.max
          ? '${lengths.min}'
          : '${lengths.min}–${lengths.max}';
      return 'Enter a valid @count-digit number for @country'.trParams({
        'count': rangeText,
        'country': (selectedCountry.value.name ?? '').tr,
      });
    }
    return null;
  }

  void onPhoneChanged(String value) {
    if (value.trim().isEmpty) {
      phoneError.value = '';
      return;
    }
    phoneError.value = validatePhone(value) ?? '';
  }

  void onCountryChanged(CountryCode countryCode) {
    selectedCountry.value = countryCode;
    phoneController.clear();
    phoneError.value = '';
  }

  // ── Email-only ────────────────────────────────────────────────────────────

  FormFieldValidator<String> get emailValidator => CommonValidators.compose([
    CommonValidators.required(message: 'validation_email_required'.tr),
    CommonValidators.email(message: 'validation_email'.tr),
  ]);

  FormFieldValidator<String> get nameValidator =>
      CommonValidators.required(message: 'validation_name_required'.tr);

  FormFieldValidator<String> get passwordValidator => CommonValidators.compose([
    CommonValidators.required(message: 'validation_password_required'.tr),
    CommonValidators.strongPassword(),
  ]);

  FormFieldValidator<String> get confirmPasswordValidator =>
      CommonValidators.compose([
        CommonValidators.required(
          message: 'validation_confirm_password_required'.tr,
        ),
        CommonValidators.match(
          () => passwordController.text,
          message: 'validation_password_mismatch'.tr,
        ),
      ]);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ── Continue ──────────────────────────────────────────────────────────────

  Future<void> handleContinue() async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }
    if (_appleRegistration?.isExpired == true) {
      AppSnackbar.show(
        "Apple sign-in".tr,
        "Apple registration expired. Please sign in with Apple again.".tr,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    final phone =
        '${selectedCountry.value.dialCode ?? ''}${phoneController.text.trim()}';
    try {
      final registration = _appleRegistration;
      final request = RegisterRequest(
        name: nameController.text.trim(),
        email:
            registration?.email ?? _googleEmail ?? emailController.text.trim(),
        appleRegistrationToken: registration?.token,
        phone: phone,
        password: passwordController.text,
      );
      final response = await Get.find<ApiRepo>().startRegister(request);
      Get.toNamed(
        AppRoutes.otpScreen,
        arguments: OtpArgs.register(
          phone: phone,
          devOtp: kDebugMode ? response.devOtp : '',
          resendRegistration: () async {
            if (registration?.isExpired == true) {
              throw StateError(
                "Apple registration expired. Go back and sign in with Apple again."
                    .tr,
              );
            }
            await Get.find<ApiRepo>().startRegister(request);
          },
        ),
      );
    } catch (error) {
      AppSnackbar.show('signup_failed'.tr, _errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  String _errorMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  // ── Social ────────────────────────────────────────────────────────────────

  final RxBool isAppleLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  Future<void> handleAppleSignUp() async {
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    isAppleLoading.value = true;
    try {
      await AppleAuthFlow.run(onSignup: _applyAppleRegistration);
    } finally {
      isAppleLoading.value = false;
    }
  }

  Future<void> handleGoogleSignUp() async {
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    isGoogleLoading.value = true;
    try {
      await GoogleAuthFlow.run(
        onSignup: (name, email) {
          _appleRegistration = null;
          _googleEmail = email;
          if (name.isNotEmpty) nameController.text = name;
          emailController.text = email;
        },
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void navigateToLogin() => Get.back();

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    mode = (args is SignUpArgs) ? args.mode : SignUpMode.phone;
    emailController.addListener(_restoreProviderEmail);
    if (args is AppleRegistration) _applyAppleRegistration(args);
    if (args is GoogleSignupDetails) {
      _googleEmail = args.email;
      if (args.name.isNotEmpty) nameController.text = args.name;
      emailController.text = args.email;
    }
  }

  @override
  void onClose() {
    emailController.removeListener(_restoreProviderEmail);
    _appleRegistration = null;
    // phoneController.dispose();
    // emailController.dispose();
    // nameController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }
}
