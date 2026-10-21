import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'plan_api.dart';

class PlanPaymentGateway {
  Future<bool> pay(PlanCheckout checkout) async {
    Stripe.publishableKey = checkout.order['publishableKey'] as String;
    Stripe.urlScheme = 'squadonsite';
    await Stripe.instance.applySettings();
    final secret = checkout.order['clientSecret'] as String;
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'SquadOnSite',
        paymentIntentClientSecret: secret,
        returnURL: 'squadonsite://stripe-redirect',
        style: ThemeMode.light,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    final intent = await Stripe.instance.retrievePaymentIntent(secret);
    return intent.id == checkout.intentId &&
        intent.status == PaymentIntentsStatus.Succeeded;
  }
}

class PlansController extends GetxController {
  PlansController({
    required this.api,
    required this.customerId,
    PlanPaymentGateway? gateway,
  }) : gateway = gateway ?? PlanPaymentGateway();
  final PlanApi api;
  final String? Function() customerId;
  final PlanPaymentGateway gateway;
  final plans = <ApiPlan>[].obs;
  final purchases = <PlanPurchase>[].obs;
  final loading = false.obs, busy = false.obs, historyLoading = false.obs;
  final error = ''.obs, historyError = ''.obs, message = ''.obs;
  final category = 'Residential'.obs;
  final durationYears = 1.obs;
  final pending = Rxn<Map<String, String>>();
  String? _owner;
  int _catalogRequestVersion = 0;

  static PlansController ensure() => Get.isRegistered<PlansController>()
      ? Get.find<PlansController>()
      : Get.put(
          PlansController(
            api: PlanApi(Get.find<ApiRepo>()),
            customerId: () {
              if (!Get.isRegistered<AuthSession>()) return null;
              final session = Get.find<AuthSession>();
              return session.hasToken ? session.user?.id : null;
            },
          ),
          permanent: true,
        );

  Future<void> _restore() async {
    final owner = customerId();
    if (_owner != owner) {
      purchases.clear();
      pending.value = null;
      message.value = '';
      historyError.value = '';
      _owner = owner;
    }
    if (owner == null) return;
    final saved = (await SharedPreferences.getInstance()).getString(
      'plan_checkout_$owner',
    );
    if (saved != null) {
      pending.value = Map<String, String>.from(jsonDecode(saved));
    }
  }

  Future<void> load() async {
    final requestVersion = ++_catalogRequestVersion;
    loading.value = true;
    error.value = '';
    try {
      final result = await api.catalog(
        category: category.value,
        durationYears: durationYears.value,
      );
      if (requestVersion == _catalogRequestVersion) plans.assignAll(result);
    } catch (e) {
      if (requestVersion == _catalogRequestVersion) error.value = _error(e);
    } finally {
      if (requestVersion == _catalogRequestVersion) loading.value = false;
    }
  }

  Future<void> selectCategory(String value) async {
    if (category.value == value) return;
    category.value = value;
    await load();
  }

  Future<void> selectDuration(int value) async {
    if (durationYears.value == value) return;
    durationYears.value = value;
    await load();
  }

  Future<void> refreshHistory() async {
    if (historyLoading.value) return;
    historyLoading.value = true;
    try {
      await _restore();
      final owner = customerId();
      if (owner == null) return;
      final result = await api.history();
      if (customerId() == owner) {
        purchases.assignAll(result);
        historyError.value = '';
      }
    } catch (e) {
      historyError.value = _error(e);
    } finally {
      historyLoading.value = false;
    }
  }

  Future<void> subscribe(ApiPlan plan) async {
    if (busy.value) return;
    if (customerId() == null) {
      message.value = 'Please sign in before purchasing a plan.';
      return;
    }
    busy.value = true;
    message.value = '';
    try {
      await _restore();
      if (pending.value != null) {
        message.value =
            'Check your previous payment before starting another purchase.';
        return;
      }
      final owner = customerId()!;
      final checkout = await api.create(plan.id);
      if (customerId() != owner) return;
      // The server may have changed its catalog since the screen loaded.
      if (checkout.purchase.price != plan.price ||
          checkout.purchase.currency != plan.currency ||
          checkout.purchase.months != plan.months) {
        message.value =
            'Plan pricing changed. Refresh plans and review the new price before paying.';
        return;
      }
      final saved = {
        'purchaseId': checkout.purchase.id,
        'intentId': checkout.intentId,
      };
      // Persist IDs before opening Stripe; never persist card data or secrets.
      await (await SharedPreferences.getInstance()).setString(
        'plan_checkout_$owner',
        jsonEncode(saved),
      );
      pending.value = saved;
      try {
        if (!await gateway.pay(checkout)) {
          message.value =
              'Payment is processing. Use Check payment to verify it later.';
          return;
        }
      } on StripeException catch (e) {
        if (e.error.code == FailureCode.Canceled) {
          await _clearPending(owner);
          message.value = 'Payment canceled. No plan was activated.';
          return;
        }
        rethrow;
      }
      await _verify(owner);
    } catch (e) {
      message.value = _error(e);
    } finally {
      busy.value = false;
    }
  }

  Future<void> retryVerification() async {
    if (busy.value || customerId() == null) return;
    busy.value = true;
    message.value = '';
    try {
      await _restore();
      await _verify(customerId()!);
    } catch (e) {
      message.value = _error(e);
    } finally {
      busy.value = false;
    }
  }

  Future<void> _verify(String owner) async {
    final saved = pending.value;
    if (saved == null || customerId() != owner) return;
    final purchase = await api.verify(saved['purchaseId']!, saved['intentId']!);
    if (purchase.id != saved['purchaseId'] || purchase.status != 'active') {
      throw StateError(
        'Payment is not confirmed yet. Check payment again shortly.',
      );
    }
    if (customerId() != owner) return;
    purchases.removeWhere((p) => p.id == purchase.id);
    purchases.insert(0, purchase);
    await _clearPending(owner);
    message.value = '${purchase.name} is active.';
  }

  Future<void> _clearPending(String owner) async {
    await (await SharedPreferences.getInstance()).remove(
      'plan_checkout_$owner',
    );
    if (customerId() == owner) pending.value = null;
  }

  String _error(Object e) {
    if (e is ApiException) {
      return switch (e.statusCode) {
        401 => 'Your session expired. Please sign in again.',
        403 => 'This account is not allowed to purchase plans.',
        404 => 'This plan or purchase is no longer available.',
        409 => 'Payment is not confirmed yet. Use Check payment to retry.',
        503 => 'Payments are temporarily unavailable. Please try again later.',
        _ => e.message,
      };
    }
    if (e is StripeException) {
      return e.error.localizedMessage ??
          'Payment failed. Check payment before trying another purchase.';
    }
    return 'Unable to complete the request. Please retry. If you paid, use Check payment.';
  }
}
