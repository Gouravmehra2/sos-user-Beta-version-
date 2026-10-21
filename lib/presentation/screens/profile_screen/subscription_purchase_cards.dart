import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plan_api.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_screen.dart';

class SubscriptionPurchaseCards extends StatelessWidget {
  const SubscriptionPurchaseCards({super.key, required this.controller});

  final PlansController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
    final loading = controller.historyLoading.value;
    final error = controller.historyError.value;
    final purchases = controller.purchases.toList();
    // Keep all purchases visible; prioritize current coverage, then recent payments.
    purchases.sort((a, b) {
      final active =
          (b.status == 'active' ? 1 : 0) - (a.status == 'active' ? 1 : 0);
      if (active != 0) return active;
      return (b.paidAt ?? b.startsAt ?? DateTime(1970)).compareTo(
        a.paidAt ?? a.startsAt ?? DateTime(1970),
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (loading) ...[
          const LinearProgressIndicator(color: Colors.black),
          const SizedBox(height: 12),
        ],
        if (error.isNotEmpty) ...[
          const Text(
            'Unable to refresh your purchases. Please try again.',
            style: TextStyle(color: Colors.black54),
          ),
          TextButton(
            onPressed: controller.refreshHistory,
            child: const Text('Retry'),
          ),
        ],
        if (purchases.isEmpty)
          _CardFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  loading
                      ? 'Loading your plans…'
                      : error.isNotEmpty
                      ? 'Purchases unavailable'
                      : 'Your next plan starts here',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loading
                      ? 'Fetching your purchase details.'
                      : error.isNotEmpty
                      ? 'Your purchase details could not be loaded.'
                      : 'Your purchased plans and coverage details will appear here.',
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
                if (!loading && error.isEmpty) ...[
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      var dashboardController = Get.put(DashboardController());
                      dashboardController.changeIndex(index: 2);
                    },
                    child: const Text('Explore plans'),
                  ),
                ],
              ],
            ),
          ),
        for (var index = 0; index < purchases.length; index++) ...[
          if (index > 0) const SizedBox(height: 10),
          _PurchaseCard(purchase: purchases[index]),
        ],
      ],
    );
  });
}

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({required this.purchase});

  final PlanPurchase purchase;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final amount = NumberFormat.currency(
      locale: locale,
      name: purchase.currency.toUpperCase(),
      symbol: purchase.currency.toUpperCase() == 'USD'
          ? r'$'
          : '${purchase.currency.toUpperCase()} ',
    ).format(purchase.price);
    final pending = purchase.status.toLowerCase() == 'pending';
    String date(DateTime value) =>
        DateFormat.yMMM(locale).format(value.toLocal());
    return _CardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              purchase.status.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            purchase.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            purchase.paidAt != null ? 'Amount paid' : 'Plan price',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          // if (purchase.startsAt != null ||
          //     purchase.expiresAt != null ||
          //     purchase.paidAt != null) ...[
          //   const Divider(color: Colors.white24, height: 24),
          //   Wrap(
          //     spacing: 20,
          //     runSpacing: 10,
          //     children: [
          //       if (purchase.startsAt != null)
          //         _detail('Coverage starts', date(purchase.startsAt!)),
          //       if (purchase.expiresAt != null)
          //         _detail('Coverage ends', date(purchase.expiresAt!)),
          //       if (purchase.paidAt != null)
          //         _detail('Purchased on', date(purchase.paidAt!)),
          //     ],
          //   ),
          // ],
          if (pending) ...[
            const SizedBox(height: 12),
            const Text(
              'Payment awaiting verification. Coverage is not active yet.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  String _duration(int months) {
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    return [
      if (years > 0) '$years ${years == 1 ? 'year' : 'years'}',
      if (remainingMonths > 0 || years == 0)
        '$remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}',
    ].join(' ');
  }

  Widget _detail(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _CardFrame extends StatelessWidget {
  const _CardFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: AppColor.subscriptionCardGradient,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
      children: [
        const Positioned(
          right: -12,
          top: 12,
          child: ExcludeSemantics(
            child: Icon(
              Icons.workspace_premium,
              size: 100,
              color: Color(0x15FFFFFF),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(16), child: child),
      ],
    ),
  );
}
