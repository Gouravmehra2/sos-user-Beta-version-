import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/otp_screen/otp_controller.dart';

void main() {
  testWidgets(
    'registration resend waits for backend before clearing OTP and restarting timer',
    (tester) async {
      Get.testMode = true;
      final response = Completer<void>();
      var requests = 0;
      await tester.pumpWidget(
        GetMaterialApp(
          home: const SizedBox(),
          getPages: [
            GetPage(
              name: '/otp-test',
              page: () {
                Get.put(OtpController());
                return const SizedBox();
              },
            ),
          ],
        ),
      );
      Get.toNamed(
        '/otp-test',
        arguments: OtpArgs.register(
          phone: '+919876543210',
          resendRegistration: () {
            requests++;
            return response.future;
          },
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<OtpController>();
      controller.canResend.value = true;
      controller.pinController.text = '123456';
      controller.otpValue.value = '123456';
      final resend = controller.handleResend();
      expect(requests, 1);
      expect(controller.isResending.value, isTrue);
      expect(controller.otpValue.value, '123456');
      response.complete();
      await resend;
      expect(controller.pinController.text, isEmpty);
      expect(controller.otpValue.value, isEmpty);
      expect(controller.isResending.value, isFalse);
      expect(controller.canResend.value, isFalse);
      expect(controller.phone, '+919876543210');
      Get.delete<OtpController>(force: true);
      await tester.pumpWidget(const SizedBox());
      Get.reset();
    },
  );
}
