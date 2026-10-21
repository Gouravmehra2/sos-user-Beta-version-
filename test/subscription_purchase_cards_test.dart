import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plan_api.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'package:squadonsite/presentation/screens/profile_screen/subscription_purchase_cards.dart';
import 'plan_test_support.dart';

void main() {
  testWidgets(
    'shows real purchase details and fits large text on narrow screens',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = PlansController(
        api: FakePlanApi(),
        customerId: () => 'customer',
      );
      controller.purchases.add(
        PlanPurchase({
          ...purchaseJson('active'),
          'paidAt': '2026-10-01T12:00:00Z',
          'startsAt': '2026-10-01T12:00:00Z',
          'expiresAt': '2027-10-01T12:00:00Z',
        }),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: SingleChildScrollView(
                child: SubscriptionPurchaseCards(controller: controller),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Pro SOS Plan'), findsOneWidget);
      expect(find.text(r'$1,725.00'), findsOneWidget);
      expect(find.text('Coverage ends'), findsOneWidget);
      expect(find.text('1 year of coverage'), findsOneWidget);
      expect(find.text('Oct 2026'), findsNWidgets(2));
      expect(find.text('Oct 2027'), findsOneWidget);
      expect(find.text('Amount paid'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('distinguishes empty, failed and pending purchases', (
    tester,
  ) async {
    final controller = PlansController(
      api: FakePlanApi(),
      customerId: () => 'customer',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SubscriptionPurchaseCards(controller: controller),
          ),
        ),
      ),
    );
    expect(find.text('Explore plans'), findsOneWidget);
    controller.historyError.value = 'Error';
    await tester.pump();
    expect(find.text('Purchases unavailable'), findsOneWidget);
    expect(find.text('Explore plans'), findsNothing);
    controller.historyError.value = '';
    controller.purchases.add(PlanPurchase(purchaseJson()));
    await tester.pump();
    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('Plan price'), findsOneWidget);
    expect(find.text('Amount paid'), findsNothing);
    expect(find.textContaining('Coverage is not active yet'), findsOneWidget);
  });
}
