import 'package:get/get.dart' hide Response;
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';

Map<String, dynamic> planData(dynamic body) {
  if (body is! Map || body['success'] != true || body['data'] is! Map) {
    throw FormatException("Invalid plan response".tr);
  }
  return Map<String, dynamic>.from(body['data'] as Map);
}

class ApiPlan {
  ApiPlan(Map<String, dynamic> json)
    : id = json['_id'] as String,
      name = json['name'] as String,
      description = json['description'] as String? ?? '',
      tagline = json['tagline'] as String? ?? '',
      price = json['price'] as num,
      currency = json['currency'] as String,
      months = json['durationMonths'] as int,
      features = List<String>.from(json['features'] as List? ?? []),
      featured = json['isFeatured'] == true,
      active = json['isActive'] == true;
  final String id, name, description, tagline, currency;
  final num price;
  final int months;
  final List<String> features;
  final bool featured, active;
  String get amount =>
      '${currency.toUpperCase() == 'USD' ? r'$' : '${currency.toUpperCase()} '}${price.toStringAsFixed(2)}';
}

class PlanPurchase {
  PlanPurchase(Map<String, dynamic> json)
    : id = json['_id'] as String,
      name = json['planName'] as String,
      status = json['status'] as String,
      price = json['price'] as num,
      currency = json['currency'] as String,
      months = json['durationMonths'] as int,
      paidAt = DateTime.tryParse('${json['paidAt']}'),
      startsAt = DateTime.tryParse('${json['startsAt']}'),
      expiresAt = DateTime.tryParse('${json['expiresAt']}');
  final String id, name, status, currency;
  final num price;
  final int months;
  final DateTime? paidAt, startsAt, expiresAt;
}

class PlanCheckout {
  PlanCheckout(Map<String, dynamic> data)
    : purchase = PlanPurchase(Map<String, dynamic>.from(data['planPurchase'])),
      order = Map<String, dynamic>.from(data['paymentOrder']) {
    if (order['provider'] != 'stripe' ||
        (order['id'] as String? ?? '').isEmpty ||
        (order['clientSecret'] as String? ?? '').isEmpty ||
        !(order['publishableKey'] as String? ?? '').startsWith('pk_') ||
        order['amount'] is! num ||
        (order['amount'] as num) <= 0 ||
        order['currency'] != purchase.currency ||
        data['planPurchase']['paymentIntentId'] != order['id']) {
      throw const FormatException('Invalid payment order');
    }
  }
  final PlanPurchase purchase;
  final Map<String, dynamic> order;
  String get intentId => order['id'] as String;
}

class PlanApi {
  PlanApi(this.repo);
  final ApiRepo repo;
  Future<List<ApiPlan>> catalog({String? category, int? durationYears}) async {
    final queryParameters = <String, dynamic>{
      if (category != null) 'category': category,
      if (durationYears != null) 'durationYears': durationYears,
    };
    final data = planData(
      (await repo.dioClient.get(
        ApiEndpoints.plans,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      )).data,
    );
    return (data['plans'] as List)
        .map((p) => ApiPlan(Map<String, dynamic>.from(p)))
        .where((p) => p.active)
        .toList();
  }

  Future<PlanCheckout> create(String planId) async => PlanCheckout(
    planData(
      (await repo.dioClient.post(
        ApiEndpoints.planPurchases,
        data: {'planId': planId},
      )).data,
    ),
  );
  Future<PlanPurchase> verify(String purchaseId, String intentId) async {
    final data = planData(
      (await repo.dioClient.post(
        ApiEndpoints.verifyPlanPurchase,
        data: {'planPurchaseId': purchaseId, 'stripePaymentIntentId': intentId},
      )).data,
    );
    return PlanPurchase(Map<String, dynamic>.from(data['planPurchase']));
  }

  Future<List<PlanPurchase>> history() async {
    final data = planData(
      (await repo.dioClient.get(ApiEndpoints.myPlanPurchases)).data,
    );
    return ((data['planPurchases'] ?? data['purchases']) as List)
        .map((p) => PlanPurchase(Map<String, dynamic>.from(p)))
        .toList();
  }
}
