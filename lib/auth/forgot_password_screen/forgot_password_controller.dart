import 'dart:async';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/password_reset_api.dart';
import 'package:squadonsite/auth/otp_screen/otp_controller.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';

// ── Mode ──────────────────────────────────────────────────────────────────────

/// Determines whether the forgot-password screen shows a phone or email field.
enum ForgotPasswordMode { phone, email }

// ── Args ─────────────────────────────────────────────────────────────────────

/// Pass when navigating to ForgotPasswordScreen.
///
/// From phone login:
/// ```dart
/// Get.toNamed(AppRoutes.forgotPasswordScreen);          // defaults to phone
/// ```
///
/// From email login:
/// ```dart
/// Get.toNamed(
///   AppRoutes.forgotPasswordScreen,
///   arguments: ForgotPasswordArgs.email(prefillEmail: 'user@example.com'),
/// );
/// ```
class ForgotPasswordArgs {
  final ForgotPasswordMode mode;
  final String prefillEmail;

  const ForgotPasswordArgs._({required this.mode, this.prefillEmail = ''});

  factory ForgotPasswordArgs.phone() =>
      const ForgotPasswordArgs._(mode: ForgotPasswordMode.phone);

  factory ForgotPasswordArgs.email({String prefillEmail = ''}) =>
      ForgotPasswordArgs._(
        mode: ForgotPasswordMode.email,
        prefillEmail: prefillEmail,
      );
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
  'SG': (min: 8, max: 8),
  'NZ': (min: 8, max: 9),
  'MY': (min: 9, max: 10),
};

// ── Controller ────────────────────────────────────────────────────────────────

class ForgotPasswordController extends GetxController {
  ForgotPasswordController({PasswordResetApi? passwordResetApi})
    : passwordResetApi =
          passwordResetApi ?? PasswordResetApi(ApiEndpoints.apiBaseUrl);

  final PasswordResetApi passwordResetApi;

  // ── Mode ──────────────────────────────────────────────────────────────────

  late ForgotPasswordMode mode;

  bool get isEmailMode => mode == ForgotPasswordMode.email;

  /// UI strings that adapt to mode.
  String get subtitleText =>
      isEmailMode ? 'forgot_subtitle_email'.tr : 'forgot_subtitle_phone'.tr;

  String get fieldHintText =>
      isEmailMode ? 'forgot_hint_email'.tr : 'forgot_hint_phone'.tr;

  String get buttonLabel => 'forgot_btn'.tr;

  // ── Form ──────────────────────────────────────────────────────────────────

  /// Single controller used for both phone and email input.
  final TextEditingController inputController = TextEditingController();

  late GlobalKey<FormState> formKey;

  // ── Phone-only: country picker ────────────────────────────────────────────

  final Rx<CountryCode> selectedCountry = CountryCode(
    code: 'US',
    dialCode: '+1',
    name: 'United States',
  ).obs;

  final RxString phoneError = ''.obs;

  void onCountryChanged(CountryCode countryCode) {
    selectedCountry.value = countryCode;
    inputController.clear();
    phoneError.value = '';
  }

  ({int min, int max}) get _digitLengths {
    final code = selectedCountry.value.code?.toUpperCase() ?? '';
    return _countryDigitLengths[code] ?? (min: 6, max: 15);
  }

  List<TextInputFormatter> get phoneFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(_digitLengths.max),
  ];

  // ── Validation ────────────────────────────────────────────────────────────

  String? validateInput(String? value) {
    if (isEmailMode) {
      return CommonValidators.compose([
        CommonValidators.required(message: 'validation_email_required'.tr),
        CommonValidators.email(),
      ])(value);
    }
    // Phone validation
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

  void onInputChanged(String value) {
    if (isEmailMode) return; // email has no live error
    if (value.trim().isEmpty) {
      phoneError.value = '';
      return;
    }
    phoneError.value = validateInput(value) ?? '';
  }

  // ── State ─────────────────────────────────────────────────────────────────

  final RxBool isLoading = false.obs;

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> handleGetRecoveryLink() async {
    if (isLoading.value || !formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final identifier = isEmailMode
          ? inputController.text.trim()
          : '${selectedCountry.value.dialCode ?? ''}'
                '${inputController.text.replaceAll(RegExp(r'\D'), '')}';
      final response = await passwordResetApi.forgotPassword(identifier);
      final phone = response['phone'];
      if (phone is! String || phone.trim().isEmpty) {
        throw FormatException(
          "The server did not return a valid phone number.".tr,
        );
      }
      final resendAfter = _responseSeconds(response['resendAfter'], 60);
      final expiresIn = _responseSeconds(response['expiresIn'], 300);
      unawaited(
        Get.toNamed(
          AppRoutes.otpScreen,
          arguments: OtpArgs.passwordReset(
            api: passwordResetApi,
            identifier: identifier.trim(),
            phone: phone,
            resendAfter: resendAfter,
            expiresIn: expiresIn,
          ),
        ),
      );
    } on ResetApiException catch (error) {
      _showError(error.message);
    } on TimeoutException {
      _showError('forgot_request_timeout'.tr);
    } on SocketException {
      _showError('network_retry'.tr);
    } on http.ClientException {
      _showError('network_retry'.tr);
    } on FormatException catch (error) {
      _showError(
        error.message.isEmpty ? 'unexpected_server_response'.tr : error.message,
      );
    } catch (error, stackTrace) {
      debugPrint('Forgot-password request failed: $error\n$stackTrace');
      _showError('network_retry'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  int _responseSeconds(dynamic value, int fallback) =>
      value is num && value >= 0 ? value.toInt() : fallback;

  void _showError(String message) =>
      AppSnackbar.show('forgot_title'.tr, message);

  // ── Navigation ────────────────────────────────────────────────────────────

  void navigateBack() => Get.back();

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();

    final args = Get.arguments;
    if (args is ForgotPasswordArgs) {
      mode = args.mode;
      if (args.prefillEmail.isNotEmpty) {
        inputController.text = args.prefillEmail;
      }
    } else {
      mode = ForgotPasswordMode.phone;
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    passwordResetApi.close();
    super.onClose();
  }
}
