import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/model/apple_auth_model.dart';
import 'api_repo.dart';
import 'auth_api_service.dart';
import 'social_auth_service.dart';

class AppleAuthFlow {
  static bool _busy = false;

  static String errorMessage(String message, Iterable<String> secrets) {
    var result = message;
    for (final secret
        in secrets.where((value) => value.isNotEmpty).toList()
          ..sort((a, b) => b.length.compareTo(a.length))) {
      result = result.replaceAll(secret, '[redacted]');
    }
    return result.replaceAll(
      RegExp(r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'),
      '[redacted]',
    );
  }

  static Future<void> run({
    void Function(AppleRegistration registration)? onSignup,
  }) async {
    if (_busy) return;
    _busy = true;
    final secrets = <String>[];
    var stage = 'challenge';
    try {
      final social = Get.find<SocialAuthService>();
      if (!await social.isAppleSignInAvailable) {
        AppSnackbar.show(
          "Apple sign-in".tr,
          "Apple sign-in is unavailable on this device.".tr,
        );
        return;
      }
      final repo = Get.find<ApiRepo>();
      final challenge = await repo.appleChallenge();
      secrets.addAll([challenge.nonce, challenge.token]);
      stage = 'Apple authorization';
      // This backend expects the exact challenge nonce, without hashing.
      final identity = await social.signInWithApple(nonce: challenge.nonce);
      if (identity.isCancelled) return;
      if (!identity.isSuccess) {
        AppSnackbar.show(
          "Apple sign-in".tr,
          identity.errorMessage ?? "Please try again.".tr,
        );
        return;
      }
      final token = identity.user?.idToken;
      final authorizationCode = identity.user?.authorizationCode;
      secrets.addAll([?token, ?authorizationCode]);
      if (token == null ||
          token.trim().isEmpty ||
          authorizationCode == null ||
          authorizationCode.trim().isEmpty) {
        throw FormatException(
          "Apple returned incomplete credentials. Please sign in again.".tr,
        );
      }
      stage = 'backend token exchange';
      final result = await repo.appleLogin(
        identityToken: token,
        authorizationCode: authorizationCode,
        challengeToken: challenge.token,
      );
      final registration = result.registration;
      if (registration != null) {
        final details = registration.withName(identity.user?.displayName ?? '');
        if (onSignup != null) {
          onSignup(details);
        } else {
          if (Get.isBottomSheetOpen == true) Get.back();
          Get.toNamed(AppRoutes.signUpScreen, arguments: details);
        }
        return;
      }
      await Get.find<AuthSession>().update(result.session!);
      Get.offAllNamed(AppRoutes.splashScreen);
    } on ApiException catch (error) {
      final message = errorMessage(error.message, secrets);
      if (kDebugMode) {
        debugPrint('Apple status: ${error.statusCode} ($stage)');
        debugPrint('Apple response: $message');
      }
      AppSnackbar.show("Apple sign-in".tr, message);
    } on FormatException catch (error) {
      final message = errorMessage(error.message, secrets);
      if (kDebugMode) debugPrint('Apple response error ($stage): $message');
      AppSnackbar.show("Apple sign-in".tr, message);
    } catch (error) {
      if (kDebugMode) debugPrint('Apple sign-in failed: ${error.runtimeType}');
      AppSnackbar.show(
        "Apple sign-in".tr,
        "Unable to complete Apple sign-in. Please try again.".tr,
      );
    } finally {
      _busy = false;
    }
  }
}
