import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/model/google_signup_details.dart';
import 'package:squadonsite/model/auth_model.dart';
import 'api_repo.dart';
import 'auth_api_service.dart';
import 'social_auth_service.dart';

/// Coordinates provider identity with the app's independent backend session.
class GoogleAuthFlow {
  static bool _busy = false;

  static Future<void> run({
    void Function(String name, String email)? onSignup,
    bool signupIfAccountMissing = false,
  }) async {
    if (_busy) return;
    _busy = true;
    SocialAuthService? social;
    try {
      social = Get.find<SocialAuthService>();
      final result = await social.signInWithGoogle();
      if (result.isCancelled) return;
      if (!result.isSuccess) {
        AppSnackbar.show(
          "Google sign-in".tr,
          result.errorMessage ??
              "Unable to sign in with Google. Please try again.".tr,
        );
        return;
      }
      final token = result.user?.accessToken;
      if (token == null || token.trim().isEmpty) {
        throw FormatException(
          "Unable to verify your Google account. Please try again.".tr,
        );
      }
      final repo = Get.find<ApiRepo>();
      if (onSignup != null) {
        final identity = await repo.googleSignup(token.trim());
        onSignup(identity.name, identity.email);
        AppSnackbar.show(
          "Google account details received".tr,
          "Complete your phone number and password, then verify your phone by OTP."
              .tr,
        );
      } else {
        final AuthResponse response;
        try {
          response = await repo.googleLogin(token.trim());
        } on ApiException catch (error) {
          if (error.statusCode != 404 || !signupIfAccountMissing) rethrow;
          final details = await repo.googleSignup(token.trim());
          if (Get.isBottomSheetOpen == true) Get.back();
          Get.toNamed(
            AppRoutes.signUpScreen,
            arguments: GoogleSignupDetails(
              name: details.name,
              email: details.email,
            ),
          );
          return;
        }
        await Get.find<AuthSession>().update(response);
        Get.offAllNamed(AppRoutes.splashScreen);
      }
    } on ApiException catch (error) {
      if (kDebugMode) {
        debugPrint('Google authentication request failed: ${error.statusCode}');
      }
      final message = switch (error.statusCode) {
        400 => 'Unable to verify Google account details. Please try again.',
        401 =>
          'Google verification expired or was rejected. Please sign in again.',
        403 => error.message,
        404 => 'No app account exists for this Google email. Please sign up.',
        409 => 'Email is already registered. Please log in.',
        429 => 'Too many attempts. Please wait and try again.',
        _ => 'Unable to connect. Please try again.',
      };
      AppSnackbar.show(
        "Google sign-in".tr,
        message,
        mainButton: error.statusCode == 404 || error.statusCode == 409
            ? TextButton(
                onPressed: () => Get.toNamed(
                  error.statusCode == 404
                      ? AppRoutes.signUpScreen
                      : AppRoutes.emailLoginScreen,
                ),
                child: Text(
                  (error.statusCode == 404 ? "Sign up".tr : "Log in".tr).tr,
                ),
              )
            : null,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Google authentication flow failed: ${error.runtimeType}');
      }
      AppSnackbar.show(
        "Google sign-in".tr,
        "Unable to complete Google sign-in. Please try again.".tr,
      );
    } finally {
      // Provider credentials are transient; AuthSession holds only app tokens.
      try {
        await social?.signOutGoogle();
      } finally {
        _busy = false;
      }
    }
  }
}
