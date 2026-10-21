import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:squadonsite/auth/reset_password_screen/reset_password_controller.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/services/password_reset_api.dart';
import 'package:squadonsite/model/auth_model.dart';

enum OtpVerifyMode { phone, email, passwordReset }

class OtpArgs {
  final OtpVerifyMode mode;
  final String dialCode;
  final String phone;
  final String email;
  final String devOtp;
  final String identifier;
  final PasswordResetApi? passwordResetApi;
  final int resendAfter;
  final int expiresIn;
  final Future<void> Function()? resendRegistration;

  const OtpArgs._({
    required this.mode,
    this.dialCode = '',
    this.phone = '',
    this.email = '',
    this.devOtp = '',
    this.identifier = '',
    this.passwordResetApi,
    this.resendAfter = 30,
    this.expiresIn = 0,
    this.resendRegistration,
  });

  factory OtpArgs.phone({required String dialCode, required String phone}) =>
      OtpArgs._(mode: OtpVerifyMode.phone, dialCode: dialCode, phone: phone);

  factory OtpArgs.register({
    required String phone,
    String devOtp = '',
    Future<void> Function()? resendRegistration,
  }) => OtpArgs._(
    mode: OtpVerifyMode.phone,
    phone: phone,
    devOtp: devOtp,
    resendRegistration: resendRegistration,
    expiresIn: 300,
  );

  factory OtpArgs.email({required String email}) =>
      OtpArgs._(mode: OtpVerifyMode.email, email: email);

  factory OtpArgs.passwordReset({
    required PasswordResetApi api,
    required String identifier,
    required String phone,
    required int resendAfter,
    required int expiresIn,
  }) => OtpArgs._(
    mode: OtpVerifyMode.passwordReset,
    identifier: identifier,
    phone: phone,
    passwordResetApi: api,
    resendAfter: resendAfter,
    expiresIn: expiresIn,
  );
}

class OtpController extends GetxController with WidgetsBindingObserver {
  late OtpVerifyMode mode;
  late String dialCode;
  late String phone;
  late String email;
  late String devOtp;
  late String identifier;
  PasswordResetApi? passwordResetApi;
  Future<void> Function()? _resendRegistration;

  bool get isEmailMode => mode == OtpVerifyMode.email;
  bool get isPasswordReset => mode == OtpVerifyMode.passwordReset;
  bool get isCodeExpired => isPasswordReset && expiresInRemaining.value == 0;

  String get maskedDestination => isEmailMode
      ? email
      : isPasswordReset
      ? _formatPhone(phone)
      : '$dialCode ${_formatPhone(phone)}';

  String get titleText => isPasswordReset
      ? 'reset_otp_title'.tr
      : isEmailMode
      ? 'otp_title_email'.tr
      : 'otp_title_phone'.tr;

  String get subtitleText => 'otp_subtitle'.trArgs([maskedDestination]);

  String get changeLinkText =>
      isEmailMode ? 'otp_change_email'.tr : 'otp_change_number'.tr;

  final TextEditingController pinController = TextEditingController();
  late GlobalKey<FormState> formKey;
  final RxString otpValue = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  void onOtpChanged(String value) => otpValue.value = value;
  void onOtpCompleted(String value) => otpValue.value = value;

  static const int _resendSeconds = 30;
  final RxInt secondsRemaining = _resendSeconds.obs;
  final RxInt expiresInRemaining = 0.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;
  DateTime? _resendDeadline;
  DateTime? _expiryDeadline;

  void _startTimer({
    int resendAfter = _resendSeconds,
    int? expiresIn,
    bool preserveExpiry = false,
  }) {
    _timer?.cancel();
    final now = DateTime.now();
    _resendDeadline = now.add(Duration(seconds: resendAfter));
    if (!preserveExpiry) {
      _expiryDeadline = expiresIn == null
          ? null
          : now.add(Duration(seconds: expiresIn));
    }
    _refreshCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshCountdown();
    });
  }

  void _refreshCountdown() {
    final now = DateTime.now();
    secondsRemaining.value = _remainingSeconds(_resendDeadline, now);
    canResend.value = secondsRemaining.value == 0;
    expiresInRemaining.value = _remainingSeconds(_expiryDeadline, now);
    if (canResend.value && (_expiryDeadline == null || isCodeExpired)) {
      _timer?.cancel();
      _timer = null;
    }
  }

  int _remainingSeconds(DateTime? deadline, DateTime now) {
    if (deadline == null) return 0;
    final remainingMilliseconds = deadline.difference(now).inMilliseconds;
    if (remainingMilliseconds <= 0) return 0;
    return (remainingMilliseconds / 1000).ceil();
  }

  String get countdownText {
    final minutes = secondsRemaining.value ~/ 60;
    final seconds = secondsRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get expiryCountdownText {
    final minutes = expiresInRemaining.value ~/ 60;
    final seconds = expiresInRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> handleVerify() async {
    if (!formKey.currentState!.validate() || isLoading.value) return;

    if (isPasswordReset) {
      if (isCodeExpired) {
        AppSnackbar.show(titleText, 'reset_otp_expired'.tr);
        return;
      }
      final api = passwordResetApi;
      if (api == null) {
        AppSnackbar.show(titleText, 'reset_session_expired'.tr);
        return;
      }
      Get.toNamed(
        AppRoutes.resetPasswordScreen,
        arguments: ResetPasswordArgs(
          api: api,
          phone: phone,
          otp: otpValue.value,
        ),
      );
      return;
    }
    if (isEmailMode) return;

    isLoading.value = true;
    try {
      final response = await Get.find<ApiRepo>().verifyRegister(
        VerifyRegisterRequest(phone: phone, code: otpValue.value),
      );
      if (response.accessToken.trim().isEmpty) {
        throw FormatException(
          "The server did not return a login token. Please try again.".tr,
        );
      }
      await Get.find<AuthSession>().update(response);
      Get.offAllNamed(AppRoutes.splashScreen);
    } catch (error) {
      AppSnackbar.show('otp_title_phone'.tr, _errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleResend() async {
    if (!canResend.value || isResending.value || isLoading.value) return;
    if (!isPasswordReset) {
      final resend = _resendRegistration;
      if (resend == null) {
        AppSnackbar.show(
          titleText,
          "Go back to signup to request a new registration code.".tr,
        );
        return;
      }
      isResending.value = true;
      try {
        await resend();
        pinController.clear();
        otpValue.value = '';
        _startTimer(expiresIn: 300);
      } catch (error) {
        AppSnackbar.show(titleText, _errorMessage(error));
      } finally {
        isResending.value = false;
      }
      return;
    }

    final api = passwordResetApi;
    if (api == null) {
      AppSnackbar.show(titleText, 'reset_session_expired'.tr);
      return;
    }

    isResending.value = true;
    try {
      final response = await api.resendOtp(identifier);
      pinController.clear();
      otpValue.value = '';
      _startTimer(
        resendAfter: _responseSeconds(response['resendAfter'], 60),
        expiresIn: _responseSeconds(response['expiresIn'], 300),
      );
      final message = response['message'];
      if (message is String && message.isNotEmpty) {
        AppSnackbar.show(titleText, message);
      }
    } on ResetApiException catch (error) {
      if (error.statusCode == 429) {
        _startTimer(resendAfter: 60, preserveExpiry: true);
      }
      AppSnackbar.show(titleText, error.message);
    } on TimeoutException {
      _startTimer(resendAfter: 60, preserveExpiry: true);
      AppSnackbar.show(titleText, 'reset_request_timeout'.tr);
    } on SocketException {
      AppSnackbar.show(titleText, 'network_retry'.tr);
    } on http.ClientException {
      AppSnackbar.show(titleText, 'network_retry'.tr);
    } finally {
      isResending.value = false;
    }
  }

  int _responseSeconds(dynamic value, int fallback) =>
      value is num && value >= 0 ? value.toInt() : fallback;

  void handleChangeDestination() => Get.back();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    formKey = GlobalKey<FormState>();
    final args = Get.arguments;
    if (args is OtpArgs) {
      mode = args.mode;
      dialCode = args.dialCode;
      phone = args.phone;
      email = args.email;
      devOtp = args.devOtp;
      identifier = args.identifier;
      passwordResetApi = args.passwordResetApi;
      _resendRegistration = args.resendRegistration;
    } else {
      mode = OtpVerifyMode.phone;
      dialCode = '';
      phone = '';
      email = '';
      devOtp = '';
      identifier = '';
    }
    _startTimer(
      resendAfter: args is OtpArgs ? args.resendAfter : _resendSeconds,
      expiresIn: args is OtpArgs && args.expiresIn > 0 ? args.expiresIn : null,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshCountdown();
  }

  @override
  void onClose() {
    _resendRegistration = null;
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    pinController.dispose();
    super.onClose();
  }

  String _errorMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  String _formatPhone(String raw) {
    if (raw.length <= 5) return raw;
    return '${raw.substring(0, 5)} ${raw.substring(5)}';
  }
}
