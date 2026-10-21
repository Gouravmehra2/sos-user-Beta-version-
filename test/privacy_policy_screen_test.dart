import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_controller.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_screen.dart';

class _PolicyBundle extends CachingAssetBundle {
  _PolicyBundle(this.read);
  Future<String> Function() read;

  @override
  Future<String> loadString(String key, {bool cache = true}) => read();

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}

const _validPolicy = '''
<h1>Test policy</h1><div class="subtitle">Customer policy</div>
<p>Introduction</p><h2>1. Information</h2>
<h3>Account details</h3><p>Some <strong>important</strong> information.</p>
<ol><li>First item</li><li>Second item</li></ol>
<h2>2. Contact</h2><p class="contact">Contact information</p>
''';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(() => Get.reset());

  testWidgets('loads the bundled policy and scrolls to its final section', (
    tester,
  ) async {
    final controller = Get.put(PrivacyPolicyController());
    await tester.pumpWidget(const GetMaterialApp(home: PrivacyPolicyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your privacy matters'), findsOneWidget);
    expect(find.text('SquadOnSite · Customer Privacy Policy'), findsOneWidget);
    expect(controller.errorMessage.value, isEmpty);
    expect(controller.sections, hasLength(13));
    expect(
      controller.sections.every((section) => section.blocks.isNotEmpty),
      isTrue,
    );
    await tester.scrollUntilVisible(find.text('13. Privacy questions'), 500);
    expect(find.text('13. Privacy questions'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shows loading, reports asset failure, and retries successfully',
    (tester) async {
      final pending = Completer<String>();
      final bundle = _PolicyBundle(() => pending.future);
      Get.put(PrivacyPolicyController(bundle: bundle));
      await tester.pumpWidget(
        const GetMaterialApp(home: PrivacyPolicyScreen()),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      pending.completeError(StateError('Asset unavailable'));
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
      bundle.read = () async => _validPolicy;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Test policy'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'parses rich text and rejects incomplete reloads without partial state',
    () async {
      final bundle = _PolicyBundle(() async => _validPolicy);
      final controller = PrivacyPolicyController(bundle: bundle);
      await controller.loadPolicy();
      expect(
        controller.sections.first.blocks[1].text,
        'Some important information.',
      );
      expect(controller.sections.first.blocks.last.ordered, isTrue);
      expect(controller.sections.first.blocks.last.items, [
        'First item',
        'Second item',
      ]);
      expect(controller.sections.last.blocks.single.contact, isTrue);
      for (final invalid in [
        '',
        '<h2>Missing title</h2><p>Text</p>',
        '<h1>Changed</h1><h2>Empty section</h2>',
      ]) {
        bundle.read = () async => invalid;
        await controller.loadPolicy();
        expect(controller.errorMessage.value, isNotEmpty);
        expect(controller.pageTitle.value, 'Test policy');
        expect(controller.sections, hasLength(2));
      }
      bundle.read = () async => '<h1>Updated</h1><h2>Section</h2><p>Text</p>';
      await controller.loadPolicy();
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.subtitle.value, isEmpty);
      expect(controller.sections, hasLength(1));
    },
  );

  test('ignores duplicate loads and completion after disposal', () async {
    final pending = Completer<String>();
    var reads = 0;
    final controller = PrivacyPolicyController(
      bundle: _PolicyBundle(() {
        reads++;
        return pending.future;
      }),
    );
    final load = controller.loadPolicy();
    await controller.loadPolicy();
    expect(reads, 1);
    controller.onDelete();
    pending.complete(_validPolicy);
    await load;
    expect(controller.pageTitle.value, isEmpty);
  });

  testWidgets(
    'supports narrow screens and enlarged text through the whole policy',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Get.put(PrivacyPolicyController());
      await tester.pumpWidget(
        GetMaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: const PrivacyPolicyScreen(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('13. Privacy questions'),
        400,
        maxScrolls: 120,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
