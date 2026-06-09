import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Verify mode ───────────────────────────────────────────────────────────────

/// Tells the OTP screen whether it is verifying a phone number or an email.
enum OtpVerifyMode { phone, email }

// ── Args ─────────────────────────────────────────────────────────────────────

/// Arguments passed when navigating to the OTP screen.
///
/// Phone flow (sign-up / login):
/// ```dart
/// Get.toNamed(
///   AppRoutes.otpScreen,
///   arguments: OtpArgs.phone(dialCode: '+91', phone: '9876543210'),
/// );
/// ```
///
/// Email flow (email login / forgot password):
/// ```dart
/// Get.toNamed(
///   AppRoutes.otpScreen,
///   arguments: OtpArgs.email(email: 'user@example.com'),
/// );
/// ```
class OtpArgs {
  final OtpVerifyMode mode;

  // Phone fields
  final String dialCode;
  final String phone;

  // Email field
  final String email;

  const OtpArgs._({
    required this.mode,
    this.dialCode = '',
    this.phone = '',
    this.email = '',
  });

  factory OtpArgs.phone({
    required String dialCode,
    required String phone,
  }) =>
      OtpArgs._(
        mode: OtpVerifyMode.phone,
        dialCode: dialCode,
        phone: phone,
      );

  factory OtpArgs.email({required String email}) =>
      OtpArgs._(mode: OtpVerifyMode.email, email: email);
}

// ── Controller ────────────────────────────────────────────────────────────────

class OtpController extends GetxController {
  // ── Mode & destination ────────────────────────────────────────────────────

  late OtpVerifyMode mode;

  // Phone
  late String dialCode;
  late String phone;

  // Email
  late String email;

  bool get isEmailMode => mode == OtpVerifyMode.email;

  /// Human-readable destination shown in the subtitle.
  /// e.g. "+91 98765 43210"  or  "user@example.com"
  String get maskedDestination =>
      isEmailMode ? email : '$dialCode ${_formatPhone(phone)}';

  /// Title text adapts to mode.
  String get titleText => isEmailMode ? 'Verify Email' : 'Verify Number';

  /// Subtitle text adapts to mode.
  String get subtitleText =>
      'We sent a 6-digit code to $maskedDestination';

  /// Bottom link label adapts to mode.
  String get changeLinkText =>
      isEmailMode ? 'Change Email?' : 'Change Number?';

  // ── Pin input ─────────────────────────────────────────────────────────────

  final TextEditingController pinController = TextEditingController();
  late GlobalKey<FormState> formKey;

  final RxString otpValue = ''.obs;

  void onOtpChanged(String value) => otpValue.value = value;

  void onOtpCompleted(String value) {
    otpValue.value = value;
    // Optionally auto-verify: handleVerify();
  }

  // ── Resend countdown ──────────────────────────────────────────────────────

  static const int _resendSeconds = 30;

  final RxInt secondsRemaining = _resendSeconds.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    secondsRemaining.value = _resendSeconds;
    canResend.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value <= 1) {
        t.cancel();
        secondsRemaining.value = 0;
        canResend.value = true;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  String get countdownText {
    final mins = secondsRemaining.value ~/ 60;
    final secs = secondsRemaining.value % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // ── Verify ────────────────────────────────────────────────────────────────

  void handleVerify() {
    if (!formKey.currentState!.validate()) return;

    final otp = otpValue.value;
    // TODO: Call OTP verification API
    debugPrint('Verifying OTP: $otp for $maskedDestination (${mode.name})');
  }

  // ── Resend ────────────────────────────────────────────────────────────────

  void handleResend() {
    if (!canResend.value) return;
    pinController.clear();
    otpValue.value = '';
    _startTimer();
    // TODO: Trigger resend OTP/email-code API call
    debugPrint('Resending OTP to $maskedDestination');
  }

  // ── Change destination ────────────────────────────────────────────────────

  void handleChangeDestination() => Get.back();

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();

    final args = Get.arguments;
    if (args is OtpArgs) {
      mode = args.mode;
      dialCode = args.dialCode;
      phone = args.phone;
      email = args.email;
    } else {
      // Safe fallback for direct navigation / testing
      mode = OtpVerifyMode.phone;
      dialCode = '';
      phone = '';
      email = '';
    }
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinController.dispose();
    super.onClose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatPhone(String raw) {
    if (raw.length <= 5) return raw;
    return '${raw.substring(0, 5)} ${raw.substring(5)}';
  }
}
