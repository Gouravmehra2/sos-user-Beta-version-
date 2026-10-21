import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/model/auth_model.dart';
import 'package:squadonsite/model/apple_auth_model.dart';
import 'package:squadonsite/model/google_signup_details.dart';
import 'package:squadonsite/auth/sign_up_screen/sign_up_controller.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/widget/login_bottom_sheet_controller.dart';

class Social extends SocialAuthService {
  @override
  Future<bool> get isAppleSignInAvailable async => true;
  @override
  Future<SocialAuthResult> signInWithGoogle() async => SocialAuthResult.success(
    const SocialAuthUser(
      provider: SocialProvider.google,
      uid: 'google',
      accessToken: 'google-access',
    ),
  );
  @override
  Future<SocialAuthResult> signInWithApple({required String nonce}) async =>
      SocialAuthResult.success(
        const SocialAuthUser(
          provider: SocialProvider.apple,
          uid: 'apple',
          idToken: 'apple-id',
          authorizationCode: 'apple-code',
          displayName: 'Apple Name',
        ),
      );
  @override
  Future<void> signOutGoogle() async {}
}

class Repo implements ApiRepo {
  String? signupToken;
  @override
  Future<AuthResponse> googleLogin(String token) async =>
      throw const ApiException(message: 'Account not found', statusCode: 404);
  @override
  Future<({String name, String email})> googleSignup(String token) async {
    signupToken = token;
    return (name: 'Google Name', email: 'google@example.com');
  }

  @override
  Future<AppleChallenge> appleChallenge() async =>
      const AppleChallenge(nonce: 'nonce', token: 'challenge');
  @override
  Future<AppleLoginResult> appleLogin({
    required String identityToken,
    required String authorizationCode,
    required String challengeToken,
  }) async => AppleLoginResult.registration(
    AppleRegistration(email: 'relay@privaterelay.appleid.com', token: 'ticket'),
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final apple in [false, true]) {
    testWidgets(
      '${apple ? 'Apple' : 'Google'} new account closes sheet and prefills signup',
      (tester) async {
        Get.testMode = true;
        final repo = Repo();
        Get.put<ApiRepo>(repo);
        Get.put<SocialAuthService>(Social());
        Object? args;
        SignUpController? signup;
        await tester.pumpWidget(
          GetMaterialApp(
            home: const Scaffold(),
            getPages: [
              GetPage(
                name: AppRoutes.signUpScreen,
                page: () {
                  args = Get.arguments;
                  signup ??= Get.put(SignUpController());
                  return const Scaffold(body: Text('Signup destination'));
                },
              ),
            ],
          ),
        );
        Get.bottomSheet(const SizedBox(height: 100));
        await tester.pumpAndSettle();
        final controller = LoginBottomSheetController();
        if (apple) {
          await controller.handleAppleLogin();
        } else {
          await controller.handleGoogleLogin();
        }
        await tester.pumpAndSettle();
        expect(Get.currentRoute, AppRoutes.signUpScreen);
        expect(Get.isBottomSheetOpen, isNot(true));
        expect(find.text('Signup destination'), findsOneWidget);
        expect(controller.isAppleLoading.value, isFalse);
        expect(controller.isGoogleLoading.value, isFalse);
        expect(
          signup!.nameController.text,
          apple ? 'Apple Name' : 'Google Name',
        );
        final email = apple
            ? 'relay@privaterelay.appleid.com'
            : 'google@example.com';
        expect(signup!.emailController.text, email);
        signup!.emailController.text = 'changed@example.com';
        expect(signup!.emailController.text, email);
        if (apple) {
          expect((args as AppleRegistration).token, 'ticket');
        } else {
          expect(args, isA<GoogleSignupDetails>());
          expect(repo.signupToken, 'google-access');
        }
        await tester.pumpWidget(const SizedBox());
        Get.reset();
      },
    );
  }
}
