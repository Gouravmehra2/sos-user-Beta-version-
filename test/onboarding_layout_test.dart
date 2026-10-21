import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/core/services/language_service.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_controller.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_screen.dart';
import 'package:squadonsite/translations/app_translations.dart';

void main() {
  for (final size in [const Size(320, 568), const Size(390, 844)]) {
    testWidgets('onboarding keeps footer fixed at $size', (tester) async {
      Get.testMode = true;
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(Get.reset);
      Get.put(LanguageService());
      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          home: OnboardingScreen(),
        ),
      );
      await tester.pump();
      final button = find.byType(CommonButton);
      final pages = find.byType(PageView);
      final buttonRect = tester.getRect(button);
      expect(buttonRect.height, 52);
      expect(tester.getSize(pages).height, greaterThan(300));
      expect(tester.getRect(pages).bottom, lessThanOrEqualTo(buttonRect.top));
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(Get.find<OnboardingController>().currentPage.value, 1);
      await tester.drag(pages, const Offset(-350, 0));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(Get.find<OnboardingController>().currentPage.value, 2);
      expect(tester.getRect(button), buttonRect);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
