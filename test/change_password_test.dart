import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:squadonsite/constant/pages/app_pages.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/presentation/screens/change_password/change_password_binding.dart';
import 'package:squadonsite/presentation/screens/change_password/change_password_controller.dart';
import 'package:squadonsite/presentation/screens/change_password/change_password_screen.dart';
import 'package:squadonsite/presentation/screens/change_password/model/change_password_request.dart';
import 'package:squadonsite/translations/app_translations.dart';

class _PasswordApiClient extends DioClient {
  String? path;
  dynamic payload;

  @override
  Future<dio.Response> put(
    String path, {
    dynamic data,
    dio.Options? options,
  }) async {
    this.path = path;
    payload = data;
    return dio.Response(
      requestOptions: dio.RequestOptions(path: path),
      data: {'success': true},
    );
  }
}

void main() {
  test('password request excludes client-side confirmation', () {
    const request = ChangePasswordRequest(
      oldPassword: 'OldPassword1!',
      newPassword: 'NewPassword2!',
    );

    expect(request.toJson(), {
      'oldPassword': 'OldPassword1!',
      'newPassword': 'NewPassword2!',
    });
  });

  test('new password must be strong and confirmation must match', () {
    Get.testMode = true;
    addTearDown(Get.reset);
    final controller = Get.put(ChangePasswordController());
    controller.newPasswordController.text = 'StrongPassword1!';

    expect(controller.validateNewPassword('weak'), isNotNull);
    expect(controller.validateNewPassword('StrongPassword1!'), isNull);
    expect(
      controller.validateConfirmPassword('DifferentPassword1!'),
      isNotNull,
    );
    expect(controller.validateConfirmPassword('StrongPassword1!'), isNull);
  });

  testWidgets('profile Change password entry opens the three-field screen', (
    tester,
  ) async {
    Get.testMode = true;
    Get.put(AuthSession());
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        locale: const Locale('en', 'US'),
        translations: AppTranslations(),
        getPages: AppPages.getPages,
        initialRoute: AppRoutes.profileScreen,
      ),
    );

    await tester.ensureVisible(find.text('Change password'));
    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangePasswordScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('old-password-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('new-password-field')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('confirm-password-field')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('password form validates required fields', (tester) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put(ChangePasswordController());

    await tester.pumpWidget(
      GetMaterialApp(
        locale: const Locale('en', 'US'),
        translations: AppTranslations(),
        home: const ChangePasswordScreen(),
      ),
    );
    await tester.tap(find.text('Update password'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your old password'), findsWidgets);
    expect(find.text('Enter a new password'), findsWidgets);
    expect(find.text('Confirm your new password'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('successful update sends PUT and returns to previous screen', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    final api = _PasswordApiClient();
    Get.put<DioClient>(api);

    await tester.pumpWidget(
      GetMaterialApp(
        locale: const Locale('en', 'US'),
        translations: AppTranslations(),
        initialRoute: '/previous',
        getPages: [
          GetPage(
            name: '/previous',
            page: () => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.changePasswordScreen),
                  child: const Text('Previous screen'),
                ),
              ),
            ),
          ),
          GetPage(
            name: AppRoutes.changePasswordScreen,
            page: () => const ChangePasswordScreen(),
            binding: ChangePasswordBinding(),
          ),
        ],
      ),
    );
    await tester.tap(find.text('Previous screen'));
    await tester.pumpAndSettle();

    Future<void> enterPassword(String key, String value) async {
      final field = find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(field, value);
    }

    await enterPassword('old-password-field', 'OldPassword1!');
    await enterPassword('new-password-field', 'NewPassword2!');
    await enterPassword('confirm-password-field', 'NewPassword2!');
    await tester.ensureVisible(find.text('Update password'));
    await tester.tap(find.text('Update password'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(api.path, '/api/auth/change-password');
    expect(api.payload, {
      'oldPassword': 'OldPassword1!',
      'newPassword': 'NewPassword2!',
    });
    expect(find.text('Previous screen'), findsOneWidget);
    expect(find.text('Your password has been updated.'), findsOneWidget);
    Get.closeCurrentSnackbar();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
