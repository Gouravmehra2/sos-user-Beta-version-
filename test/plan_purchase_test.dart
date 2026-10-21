import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plan_api.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'plan_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakePlanApi api;
  late FakePlanGateway gateway;
  late PlansController controller;
  String? customer;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    api = FakePlanApi();
    gateway = FakePlanGateway();
    customer = 'customer1';
    controller = PlansController(
      api: api,
      customerId: () => customer,
      gateway: gateway,
    );
  });
  test('public catalog loads but guests cannot purchase', () async {
    customer = null;
    await controller.load();
    expect(controller.plans, hasLength(1));
    await controller.subscribe(ApiPlan(planJson()));
    expect(api.creates, 0);
    expect(gateway.calls, 0);
  });
  test(
    'success verifies before showing active plan without loading history',
    () async {
      await controller.subscribe(ApiPlan(planJson()));
      expect(api.creates, 1);
      expect(api.verifies, 1);
      expect(api.histories, 0);
      expect(controller.purchases.single.status, 'active');
      expect(controller.pending.value, isNull);
    },
  );
  test(
    'interrupted verification survives restart and never charges again',
    () async {
      api.verifyError = const ApiException(message: 'Offline');
      await controller.subscribe(ApiPlan(planJson()));
      expect(controller.purchases, isEmpty);
      expect(controller.pending.value, isNotNull);
      final restored = PlansController(
        api: api,
        customerId: () => customer,
        gateway: gateway,
      );
      await restored.subscribe(ApiPlan(planJson()));
      expect(api.creates, 1);
      api.verifyError = null;
      await restored.retryVerification();
      expect(api.creates, 1);
      expect(gateway.calls, 1);
      expect(api.verifies, 2);
      expect(restored.purchases.single.status, 'active');
    },
  );
  test('processing and 409 never grant access', () async {
    gateway.succeeded = false;
    await controller.subscribe(ApiPlan(planJson()));
    expect(api.verifies, 0);
    expect(controller.purchases, isEmpty);
    api.verifyError = const ApiException(message: 'Pending', statusCode: 409);
    await controller.retryVerification();
    expect(controller.pending.value, isNotNull);
    expect(controller.purchases, isEmpty);
  });
  test(
    'canceled payment grants no entitlement and allows a fresh checkout',
    () async {
      gateway.error = StripeException(
        error: LocalizedErrorMessage(code: FailureCode.Canceled),
      );
      await controller.subscribe(ApiPlan(planJson()));
      expect(api.verifies, 0);
      expect(controller.purchases, isEmpty);
      expect(controller.pending.value, isNull);
      gateway.error = null;
      await controller.subscribe(ApiPlan(planJson()));
      expect(api.creates, 2);
    },
  );
  test('a pending verification response cannot activate a plan', () async {
    api.verifiedStatus = 'pending';
    await controller.subscribe(ApiPlan(planJson()));
    expect(controller.purchases, isEmpty);
    expect(controller.pending.value, isNotNull);
  });
  test('pending purchase is isolated to the signed-in customer', () async {
    gateway.succeeded = false;
    await controller.subscribe(ApiPlan(planJson()));
    customer = 'customer2';
    await controller.retryVerification();
    expect(api.verifies, 0);
    expect(controller.pending.value, isNull);
  });
  test('changed backend price prevents opening Stripe', () async {
    await controller.subscribe(ApiPlan({...planJson(), 'price': 100}));
    expect(gateway.calls, 0);
    expect(controller.purchases, isEmpty);
  });
}
