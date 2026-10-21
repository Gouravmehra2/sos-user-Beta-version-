import 'plan_test_support.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/dashboard/dasboard_screen.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/dashboard/widgets/custom_bottom_navigation_tab.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plan_catalog.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_screen.dart';
import 'package:squadonsite/presentation/screens/terms_conditions_screen/terms_conditions_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.put(PlansController(api: FakePlanApi(), customerId: () => null));
  });
  tearDown(() => Get.reset());

  testWidgets('dashboard Plans tab fits narrow screens and opens Terms', (
    tester,
  ) async {
    Get.testMode = true;
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Get.put(
      DashboardController()..changeIndex(index: DashboardController.plansIndex),
    );
    await tester.pumpWidget(
      GetMaterialApp(
        home: const DashboardScreen(),
        getPages: [
          GetPage(
            name: AppRoutes.termsConditionsScreen,
            page: () => const TermsConditionsScreen(),
            binding: TermsConditionsBinding(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PlansScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Read Terms & Conditions'));
    await tester.tap(find.text('Read Terms & Conditions'));
    await tester.pumpAndSettle();
    expect(find.byType(TermsConditionsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('terms asset loads and final section is reachable', (
    tester,
  ) async {
    Get.testMode = true;
    final controller = Get.put(TermsConditionsController());
    await tester.pumpWidget(
      const GetMaterialApp(home: TermsConditionsScreen()),
    );
    await tester.pumpAndSettle();
    expect(controller.errorMessage.value, isEmpty);
    expect(controller.sections, hasLength(13));
    expect(find.text('Terms & Conditions'), findsNWidgets(2));
    await tester.scrollUntilVisible(
      find.text('13. Questions and updates'),
      500,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('API plan details show the full-term price', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: PlansScreen()));
    await tester.pumpAndSettle();
    expect(find.text(r'$1725.00'), findsOneWidget);
    final button = find.widgetWithText(OutlinedButton, 'View plan details');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Priority technical support.'), findsOneWidget);
    expect(find.textContaining('12 months · one-time payment'), findsOneWidget);
  });

  testWidgets('category and term selections request matching plans', (
    tester,
  ) async {
    final controller = Get.find<PlansController>();
    final api = controller.api as FakePlanApi;
    await tester.pumpWidget(const GetMaterialApp(home: PlansScreen()));
    await tester.pumpAndSettle();

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.indicatorSize, TabBarIndicatorSize.tab);
    expect(tabBar.indicator, isA<BoxDecoration>());
    expect(find.text('My plans'), findsNothing);
    expect(api.requestedCategory, 'Residential');
    expect(api.requestedDurationYears, 1);
    expect(api.histories, 0);

    await tester.tap(find.text('Business'));
    await tester.pumpAndSettle();
    expect(api.requestedCategory, 'Business');
    expect(api.histories, 0);

    await tester.tap(find.text('2 years'));
    await tester.pumpAndSettle();
    expect(api.requestedCategory, 'Business');
    expect(api.requestedDurationYears, 2);
    expect(controller.durationYears.value, 2);
  });

  testWidgets('plan cards support narrow screens with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const PlansScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Read Terms & Conditions'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Read Terms & Conditions'));
    expect(find.text('Smart SOS'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'only inactive Plans pulses, selection stops it and leaving resumes it',
    (tester) async {
      var selected = false;
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 160,
                    child: AnimatedBottomNavItem(
                      item: const BottomNavItemModel(
                        label: 'Plans',
                        icon: Icons.workspace_premium_outlined,
                        pulseWhenInactive: true,
                      ),
                      isSelected: selected,
                      onTap: () => setState(() => selected = !selected),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.hasRunningAnimations, isTrue);
      await tester.tap(find.byType(AnimatedBottomNavItem));
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
      rebuild(() => selected = false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reduced motion disables inactive tab pulse', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Material(
            child: AnimatedBottomNavItem(
              item: BottomNavItemModel(
                label: 'Plans',
                icon: Icons.star,
                pulseWhenInactive: true,
              ),
              isSelected: false,
              onTap: _noop,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });

  test('dashboard Plans index matches the current tab order', () {
    final controller = DashboardController();
    expect(controller.bottomList.map((item) => item.label), [
      'Home',
      'Services',
      'Plans',
      'Bookings',
      'Profile',
    ]);
    controller.changeIndex(index: DashboardController.plansIndex);
    expect(controller.selectedIndex, 2);
    controller.changeIndex(index: 5);
    expect(controller.selectedIndex, 2);
    expect(
      controller.bottomList.where((item) => item.pulseWhenInactive).length,
      1,
    );
    expect(businessPlans.every((plan) => !plan.prices.containsKey(3)), isTrue);
    expect(
      residentialPlans.last.benefits(3),
      contains('36 tickets · 3 per quarter'),
    );
  });
}

void _noop() {}
