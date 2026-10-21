import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plan_api.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';

Map<String, dynamic> planJson() => {
  '_id': 'plan1',
  'name': 'Pro SOS Plan',
  'tagline': 'Support for your devices',
  'description': 'Priority technical support.',
  'price': 1725,
  'currency': 'usd',
  'durationMonths': 12,
  'features': ['Coverage for 3 devices'],
  'isFeatured': true,
  'isActive': true,
};
Map<String, dynamic> purchaseJson([String status = 'pending']) => {
  '_id': 'purchase1',
  'plan': 'plan1',
  'planName': 'Pro SOS Plan',
  'price': 1725,
  'currency': 'usd',
  'durationMonths': 12,
  'status': status,
  'paymentIntentId': 'pi_example',
};

class UnusedRepo implements ApiRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePlanApi extends PlanApi {
  FakePlanApi() : super(UnusedRepo());
  int creates = 0, verifies = 0, histories = 0;
  Object? verifyError;
  Object? catalogError;
  String? requestedCategory;
  int? requestedDurationYears;
  String verifiedStatus = 'active';
  List<ApiPlan> catalogPlans = [ApiPlan(planJson())];
  @override
  Future<List<ApiPlan>> catalog({String? category, int? durationYears}) async {
    requestedCategory = category;
    requestedDurationYears = durationYears;
    if (catalogError != null) throw catalogError!;
    return catalogPlans;
  }

  @override
  Future<PlanCheckout> create(String id) async {
    creates++;
    return PlanCheckout({
      'planPurchase': purchaseJson(),
      'paymentOrder': {
        'provider': 'stripe',
        'id': 'pi_example',
        'clientSecret': 'pi_example_secret_test',
        'publishableKey': 'pk_test_example',
        'amount': 172500,
        'currency': 'usd',
      },
    });
  }

  @override
  Future<PlanPurchase> verify(String purchaseId, String intentId) async {
    verifies++;
    if (verifyError != null) throw verifyError!;
    return PlanPurchase(purchaseJson(verifiedStatus));
  }

  @override
  Future<List<PlanPurchase>> history() async {
    histories++;
    return verifies > 0 && verifyError == null
        ? [PlanPurchase(purchaseJson(verifiedStatus))]
        : [];
  }
}

class FakePlanGateway extends PlanPaymentGateway {
  int calls = 0;
  bool succeeded = true;
  Object? error;
  @override
  Future<bool> pay(PlanCheckout checkout) async {
    calls++;
    if (error != null) throw error!;
    return succeeded;
  }
}
