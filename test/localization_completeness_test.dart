import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/translations/app_translations.dart';
import 'package:squadonsite/translations/en.dart';
import 'package:squadonsite/translations/es.dart';
import 'package:squadonsite/translations/ar.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(Get.reset);
  test(
    'all three languages have matching keys and interpolation parameters',
    () {
      final parameters = RegExp(r'(?<![\w.])@([A-Za-z][A-Za-z0-9_]*)');
      for (final locale in [es, ar]) {
        expect(locale.keys.toSet(), en.keys.toSet());
        for (final entry in en.entries) {
          expect(locale[entry.key]!.trim(), isNotEmpty, reason: entry.key);
          final expected = parameters
              .allMatches(entry.value)
              .map((match) => match[1])
              .toSet();
          final actual = parameters
              .allMatches(locale[entry.key]!)
              .map((match) => match[1])
              .toSet();
          expect(actual, expected, reason: entry.key);
        }
      }
    },
  );
  test(
    'all bundled legal headings, paragraphs and list items have Spanish and Arabic translations',
    () async {
      final keys = AppTranslations().keys;
      for (final path in [
        'assets/html/privacy_policy.html',
        'assets/html/terms_conditions.html',
      ]) {
        final controller = PrivacyPolicyController(documentAsset: path);
        await controller.loadPolicy();
        expect(controller.errorMessage.value, isEmpty);
        final texts = [
          controller.pageTitle.value,
          controller.subtitle.value,
          ...controller.headerBlocks.map((block) => block.text),
          for (final section in controller.sections) ...[
            section.title,
            for (final block in section.blocks) ...[block.text, ...block.items],
          ],
        ].where((text) => text.isNotEmpty);
        for (final locale in ['es_ES', 'ar_AE']) {
          for (final text in texts) {
            expect(
              keys[locale]!.containsKey(text),
              isTrue,
              reason: '$locale: $text',
            );
          }
        }
        controller.onClose();
      }
    },
  );
  testWidgets(
    'live language switching updates retained labels and Arabic direction',
    (tester) async {
      Get.testMode = true;
      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('ar', 'AE'),
          ],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: const _RetainedLabel(),
        ),
      );
      expect(find.text('My bookings'), findsOneWidget);
      await Get.updateLocale(const Locale('es', 'ES'));
      await tester.pumpAndSettle();
      expect(find.text('Mis reservas'), findsOneWidget);
      await Get.updateLocale(const Locale('ar', 'AE'));
      await tester.pumpAndSettle();
      expect(find.text('حجوزاتي'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('حجوزاتي'))),
        TextDirection.rtl,
      );
      expect('Booking ID: @p0'.trParams({'p0': 'ABC123'}), contains('ABC123'));
      expect('PENDING'.tr, 'قيد الانتظار');
      expect('Completed'.tr, 'مكتمل');
      await tester.pumpWidget(const SizedBox());
    },
  );
}

class _RetainedLabel extends StatefulWidget {
  const _RetainedLabel();
  @override
  State<_RetainedLabel> createState() => _RetainedLabelState();
}

class _RetainedLabelState extends State<_RetainedLabel> {
  late final String label;
  @override
  void initState() {
    super.initState();
    label = 'My bookings'.tr;
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: Text(label.tr));
}
