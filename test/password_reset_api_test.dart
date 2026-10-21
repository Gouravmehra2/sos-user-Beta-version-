import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:squadonsite/auth/forgot_password_screen/forgot_password_controller.dart';
import 'package:squadonsite/auth/forgot_password_screen/forgot_password_screen.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/password_reset_api.dart';

void main() {
  test(
    'reset requests send public JSON payloads to the /api endpoints',
    () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'OTP sent',
            'phone': '+919876543210',
            'expiresIn': 300,
            'resendAfter': 60,
          }),
          200,
        );
      });
      final api = PasswordResetApi('https://test.example/api/', client: client);
      addTearDown(api.close);

      await api.forgotPassword('  user@example.com  ');
      await api.resendOtp('user@example.com');
      await api.resetPassword(
        phone: '+919876543210',
        otp: ' 123456 ',
        newPassword: 'newpass',
      );

      expect(requests.map((request) => request.url.path), [
        '/api/auth/forgot-password',
        '/api/auth/resend-otp',
        '/api/auth/reset-password',
      ]);
      expect(requests.every((request) => request.method == 'POST'), isTrue);
      expect(
        requests.every(
          (request) => request.headers['content-type'] == 'application/json',
        ),
        isTrue,
      );
      expect(jsonDecode(requests[0].body), {'identifier': 'user@example.com'});
      expect(jsonDecode(requests[1].body), {'identifier': 'user@example.com'});
      expect(jsonDecode(requests[2].body), {
        'phone': '+919876543210',
        'otp': '123456',
        'newPassword': 'newpass',
      });
    },
  );

  test('server failure preserves status and response message', () async {
    final api = PasswordResetApi(
      'https://test.example/api',
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'No matching account'}),
          404,
        ),
      ),
    );
    addTearDown(api.close);

    await expectLater(
      api.forgotPassword('unknown@example.com'),
      throwsA(
        isA<ResetApiException>()
            .having((error) => error.statusCode, 'statusCode', 404)
            .having((error) => error.message, 'message', 'No matching account'),
      ),
    );
  });

  test('rejects a base URL that does not end in /api', () {
    expect(() => PasswordResetApi('https://test.example'), throwsArgumentError);
  });

  testWidgets('forgot screen submit button sends the reset request', (
    tester,
  ) async {
    Get.testMode = true;
    final requests = <http.Request>[];
    final api = PasswordResetApi(
      'https://test.example/api',
      client: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'OTP sent',
            'phone': '+919876543210',
            'expiresIn': 300,
            'resendAfter': 60,
          }),
          200,
        );
      }),
    );
    final controller = Get.put(ForgotPasswordController(passwordResetApi: api));
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const ForgotPasswordScreen(),
        getPages: [
          GetPage(
            name: AppRoutes.otpScreen,
            page: () => const Scaffold(body: Text('otp-route')),
          ),
        ],
      ),
    );

    final phoneField = find.byWidgetPredicate(
      (widget) =>
          widget is TextFormField &&
          widget.controller == controller.inputController,
    );
    await tester.enterText(phoneField, '9876543210');
    await tester.tap(find.text(controller.buttonLabel));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(requests, hasLength(1));
    expect(requests.single.url.path, '/api/auth/forgot-password');
    expect(jsonDecode(requests.single.body), {'identifier': '+919876543210'});
    expect(find.text('otp-route'), findsOneWidget);
  });
}
