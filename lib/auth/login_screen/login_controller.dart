import 'package:squadonsite/core/services/google_auth_flow.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/auth/login_screen/model/login_screen_model.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';

// ── Per-country digit lengths (national subscriber number, digits only) ──────
// Values represent the expected digit count for a valid mobile number.
// ITU-T E.164 allows 1–15 digits total; subscriber lengths vary by country.
const Map<String, ({int min, int max})> _countryDigitLengths = {
  'IN': (min: 10, max: 10), // India
  'US': (min: 10, max: 10), // United States
  'CA': (min: 10, max: 10), // Canada
  'GB': (min: 10, max: 11), // United Kingdom
  'AU': (min: 9, max: 9), // Australia
  'AE': (min: 9, max: 9), // UAE
  'SA': (min: 9, max: 9), // Saudi Arabia
  'PK': (min: 10, max: 10), // Pakistan
  'BD': (min: 10, max: 10), // Bangladesh
  'NG': (min: 10, max: 10), // Nigeria
  'CN': (min: 11, max: 11), // China
  'JP': (min: 10, max: 11), // Japan
  'DE': (min: 10, max: 11), // Germany
  'FR': (min: 10, max: 10), // France
  'BR': (min: 10, max: 11), // Brazil
  'MX': (min: 10, max: 10), // Mexico
  'ZA': (min: 9, max: 9), // South Africa
  'KE': (min: 9, max: 9), // Kenya
  'EG': (min: 10, max: 10), // Egypt
  'IT': (min: 9, max: 10), // Italy
  'ES': (min: 9, max: 9), // Spain
  'RU': (min: 10, max: 10), // Russia
  'TR': (min: 10, max: 10), // Turkey
  'ID': (min: 9, max: 12), // Indonesia
  'PH': (min: 10, max: 10), // Philippines
  'TH': (min: 9, max: 9), // Thailand
  'VN': (min: 9, max: 10), // Vietnam
  'MY': (min: 9, max: 10), // Malaysia
  'SG': (min: 8, max: 8), // Singapore
  'NZ': (min: 8, max: 9), // New Zealand
  'AR': (min: 10, max: 10), // Argentina
  'CO': (min: 10, max: 10), // Colombia
  'CL': (min: 9, max: 9), // Chile
  'GH': (min: 9, max: 9), // Ghana
  'ET': (min: 9, max: 9), // Ethiopia
  'TZ': (min: 9, max: 9), // Tanzania
  'UG': (min: 9, max: 9), // Uganda
  'IQ': (min: 10, max: 10), // Iraq
  'IR': (min: 10, max: 10), // Iran
  'MA': (min: 9, max: 9), // Morocco
  'DZ': (min: 9, max: 9), // Algeria
  'SD': (min: 9, max: 9), // Sudan
  'UA': (min: 9, max: 9), // Ukraine
  'PL': (min: 9, max: 9), // Poland
  'NL': (min: 9, max: 9), // Netherlands
  'BE': (min: 8, max: 9), // Belgium
  'SE': (min: 9, max: 10), // Sweden
  'NO': (min: 8, max: 8), // Norway
  'DK': (min: 8, max: 8), // Denmark
  'FI': (min: 9, max: 10), // Finland
  'PT': (min: 9, max: 9), // Portugal
  'CH': (min: 9, max: 9), // Switzerland
  'AT': (min: 10, max: 11), // Austria
  'CZ': (min: 9, max: 9), // Czech Republic
  'RO': (min: 9, max: 9), // Romania
  'HU': (min: 9, max: 9), // Hungary
  'GR': (min: 10, max: 10), // Greece
  'IL': (min: 9, max: 9), // Israel
  'KW': (min: 8, max: 8), // Kuwait
  'QA': (min: 8, max: 8), // Qatar
  'BH': (min: 8, max: 8), // Bahrain
  'JO': (min: 9, max: 9), // Jordan
  'LB': (min: 8, max: 8), // Lebanon
  'LK': (min: 9, max: 9), // Sri Lanka
  'NP': (min: 10, max: 10), // Nepal
  'MM': (min: 9, max: 10), // Myanmar
  'KH': (min: 8, max: 9), // Cambodia
  'KZ': (min: 10, max: 10), // Kazakhstan
};

class LoginController extends GetxController {
  // Text editing controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable variables
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxString phoneError = ''.obs;

  final Rx<CountryCode> selectedCountry = CountryCode(
    code: 'IN',
    dialCode: '+91',
    name: 'India',
  ).obs;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Digit length helpers ────────────────────────────────────────────────────

  ({int min, int max}) get _digitLengths {
    final code = selectedCountry.value.code?.toUpperCase() ?? '';
    return _countryDigitLengths[code] ?? (min: 6, max: 15);
  }

  // ── Input formatters ────────────────────────────────────────────────────────

  /// Digits-only formatter with a length cap derived from the selected country.
  List<TextInputFormatter> get phoneFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(_digitLengths.max),
  ];

  // ── Validation ──────────────────────────────────────────────────────────────

  /// Validates that the digit count falls within the expected range for the
  /// currently selected country. Returns an error string or null.
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_phone_required'.tr;
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');
    final lengths = _digitLengths;

    if (digits.length < lengths.min || digits.length > lengths.max) {
      final rangeText = lengths.min == lengths.max
          ? '${lengths.min}-digit'
          : '${lengths.min}–${lengths.max}-digit';
      return 'Enter a valid $rangeText number for ${selectedCountry.value.name}';
    }
    return null;
  }

  // ── Real-time phone validation ──────────────────────────────────────────────

  /// Called on every keystroke. Shows an inline error only once the user
  /// has started typing so the field doesn't flash red on first tap.
  void onPhoneChanged(String value) {
    if (value.trim().isEmpty) {
      phoneError.value = '';
      return;
    }
    phoneError.value = validatePhone(value) ?? '';
  }

  // ── Country change ──────────────────────────────────────────────────────────

  void onCountryChanged(CountryCode countryCode) {
    selectedCountry.value = countryCode;
    // Clear phone field and any live error so the old number isn't
    // validated against the new country.
    phoneController.clear();
    phoneError.value = '';
  }

  // ── Password ────────────────────────────────────────────────────────────────

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ── Login ───────────────────────────────────────────────────────────────────

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    final identifier = phoneController.text.trim();
    final password = passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      AppSnackbar.show('sign_in_failed'.tr, 'validation_phone_required'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final request = LoginRequest(
        email: identifier.contains('@') ? identifier : '',
        phone: identifier.contains('@') ? null : identifier,
        password: password,
      );

      final response = await Get.find<ApiRepo>().login(request);
      if (response.accessToken.trim().isEmpty) {
        throw const FormatException(
          'The server did not return a login token. Please try again.',
        );
      }
      await Get.find<AuthSession>().update(response);
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } catch (error) {
      AppSnackbar.show('sign_in_failed'.tr, _errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  String _errorMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  // ── Navigation / Social ────────────────────────────────────────────────────

  final _socialAuth = Get.find<SocialAuthService>();

  final RxBool isAppleLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  Future<void> handleAppleLogin() async {
    if (isLoading.value || isAppleLoading.value || isGoogleLoading.value) {
      return;
    }

    isAppleLoading.value = true;
    try {
      final result = await _socialAuth.signInWithApple();
      result.fold(
        onSuccess: (user) {
          // TODO: send user.idToken to your backend, then navigate
          debugPrint('[Login] Apple user: ${user.uid}');
        },
        onFailure: (msg) => AppSnackbar.show('sign_in_failed'.tr, msg),
        onCancelled: () {},
      );
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

  void navigateToForgotPassword() =>
      Get.toNamed(AppRoutes.forgotPasswordScreen);
  void navigateToSignUp() => Get.toNamed(AppRoutes.signUpScreen);

  @override
  void onClose() {
    // phoneController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
