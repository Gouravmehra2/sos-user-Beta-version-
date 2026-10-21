import 'plan_test_support.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadonsite/core/services/language_service.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_controller.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/translations/app_translations.dart';
import 'package:squadonsite/translations/ar.dart';
import 'package:squadonsite/translations/en.dart';

class _ProfileController extends ProfileController {
  @override
  void onInit() {} // ignore: must_call_super
}

class _CachedTranslation extends StatelessWidget {
  const _CachedTranslation();

  @override
  Widget build(BuildContext context) => Text('nav_home'.tr);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'English is default and saved Arabic is restored before startup',
    () async {
      final service = LanguageService();
      await service.initialize();
      expect(service.currentLanguage.value, AppLanguage.english);
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(LanguageService.preferenceKey, 'arabic');
      final restored = LanguageService();
      await restored.initialize();
      expect(restored.locale, const Locale('ar', 'AE'));
      Get.reset();
    },
  );

  testWidgets(
    'refreshes cached translations and saves selection without losing input',
    (tester) async {
      final service = Get.put(LanguageService());
      await service.initialize();
      addTearDown(Get.reset);
      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: service.locale,
          supportedLocales: LanguageService.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: const Scaffold(
            body: Column(children: [_CachedTranslation(), TextField()]),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Keep my booking notes');
      await service.setLanguage(AppLanguage.arabic);
      await tester.pumpAndSettle();
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('Keep my booking notes'), findsOneWidget);
      expect(
        (await SharedPreferences.getInstance()).getString(
          LanguageService.preferenceKey,
        ),
        'arabic',
      );
      final restored = LanguageService();
      await restored.initialize();
      expect(restored.currentLanguage.value, AppLanguage.arabic);
      expect(tester.takeException(), isNull);
    },
  );

  test('Arabic covers every English key and preserves placeholders', () {
    expect(ar.keys.toSet(), en.keys.toSet());
    for (final key in en.keys) {
      expect(ar[key]!.trim(), isNotEmpty, reason: key);
      expect(
        '%s'.allMatches(ar[key]!).length,
        '%s'.allMatches(en[key]!).length,
        reason: key,
      );
    }
  });

  testWidgets('profile switches Arabic RTL and back to Spanish and English', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Get.testMode = true;
    final service = Get.put(LanguageService());
    Get.put<ProfileController>(_ProfileController());
    Get.put(PlansController(api: FakePlanApi(), customerId: () => null));
    addTearDown(Get.reset);
    await tester.pumpWidget(
      Obx(
        () => GetMaterialApp(
          translations: AppTranslations(),
          locale: service.locale,
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: LanguageService.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: ProfileScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    final dropdown = find.byKey(const ValueKey('profile-language-dropdown'));
    expect(tester.widget<DropdownButton<String>>(dropdown).value, 'english');
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();
    expect(tester.widget<DropdownButton<String>>(dropdown).value, 'arabic');
    expect(service.locale, const Locale('ar', 'AE'));
    expect(find.text('اللغة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('اللغة'))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);

    for (final language in [AppLanguage.spanish, AppLanguage.english]) {
      final label = language == AppLanguage.spanish ? 'Español' : 'English';
      await tester.ensureVisible(dropdown);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text(label).last);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(service.currentLanguage.value, language);
      expect(
        Directionality.of(
          tester.element(find.text('profile_settings_language'.tr)),
        ),
        TextDirection.ltr,
      );
      expect(tester.takeException(), isNull);
    }
  });
}
