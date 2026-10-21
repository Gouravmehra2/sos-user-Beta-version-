import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'plan_api.dart';
import 'plans_controller.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});
  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  late final PlansController controller;
  @override
  void initState() {
    super.initState();
    controller = PlansController.ensure();
    controller.load();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    initialIndex: controller.category.value == 'Business' ? 1 : 0,
    child: Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: Text("Plans".tr),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xff292929),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                padding: const EdgeInsets.all(4),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onTap: (index) => controller.selectCategory(
                  index == 0 ? 'Residential' : 'Business',
                ),
                tabs: [
                  Tab(text: ('Residential').tr),
                  Tab(text: ('Business').tr),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<int>(
                      segments: [
                        ButtonSegment(value: 1, label: Text("1 year".tr)),
                        ButtonSegment(value: 2, label: Text("2 years".tr)),
                        ButtonSegment(value: 3, label: Text("3 years".tr)),
                      ],
                      selected: {controller.durationYears.value},
                      onSelectionChanged: (selection) =>
                          controller.selectDuration(selection.first),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.black;
                            }
                            return Colors.white;
                          },
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.white;
                            }
                            return Colors.black;
                          },
                        ),
                        side: WidgetStateProperty.all(
                          const BorderSide(color: Color(0xFFD0D0D0), width: 1),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (controller.loading.value)
                      const LinearProgressIndicator(),
                    if (controller.error.value.isNotEmpty) ...[
                      Text((controller.error.value).tr),
                      TextButton(
                        onPressed: controller.load,
                        child: Text("Retry plans".tr),
                      ),
                    ],
                    if (!controller.loading.value &&
                        controller.error.value.isEmpty &&
                        controller.plans.isEmpty)
                      Text("No plans are currently available.".tr),
                    if (controller.pending.value != null) ...[
                      Text(
                        "A previous payment needs verification. Check it before starting another purchase."
                            .tr,
                      ),
                      FilledButton(
                        onPressed: controller.busy.value
                            ? null
                            : controller.retryVerification,
                        child: Text("Check payment".tr),
                      ),
                    ],
                    if (controller.busy.value)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: LinearProgressIndicator(),
                      ),
                    for (final plan in controller.plans)
                      _PlanCard(plan: plan, controller: controller),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.termsConditionsScreen),
                      child: Text("Read Terms & Conditions".tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.controller});
  final ApiPlan plan;
  final PlansController controller;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (plan.featured)
            Text("FEATURED".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            (plan.name).tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (plan.tagline.isNotEmpty) Text((plan.tagline).tr),
          const SizedBox(height: 12),
          Text(
            (plan.amount).tr,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            "One-time payment · @p0 months".trParams({
              "p0": (plan.months).toString(),
            }),
          ),
          const SizedBox(height: 12),
          for (final feature in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('✓ ${feature.tr}'),
            ),
          const SizedBox(height: 12),
          Obx(
            () => FilledButton(
              key: ValueKey('subscribe-${plan.id}'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed:
                  controller.busy.value || controller.pending.value != null
                  ? null
                  : () => _confirm(context),
              child: Text(
                "Subscribe to this plan".tr,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width,
                maxWidth: MediaQuery.sizeOf(context).width,
              ),
              useSafeArea: true,
              showDragHandle: true,
              builder: (context) => SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      (plan.name).tr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@p0 · @p1 months · one-time payment".trParams({
                        "p0": (plan.amount).toString(),
                        "p1": (plan.months).toString(),
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text((plan.description).tr),
                    for (final feature in plan.features)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('✓ ${feature.tr}'),
                      ),
                  ],
                ),
              ),
            ),
            child: Text("View plan details".tr),
          ),
        ],
      ),
    ),
  );

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Subscribe to @p0".trParams({"p0": (plan.name).toString()}),
        ),
        content: Text(
          "@p0 charged once for @p1 months. Enter your card details securely in Stripe to pay."
              .trParams({
                "p0": (plan.amount).toString(),
                "p1": (plan.months).toString(),
              }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel".tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Continue to payment".tr),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.subscribe(plan);
  }
}

class PlanPurchaseHistory extends StatelessWidget {
  const PlanPurchaseHistory({super.key, required this.controller});
  final PlansController controller;

  @override
  Widget build(BuildContext context) => Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "My plans".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (controller.customerId() == null)
          TextButton(
            onPressed: () async {
              await Get.toNamed(AppRoutes.loginScreen);
              await controller.refreshHistory();
            },
            child: Text("Sign in".tr),
          ),
        if (controller.historyLoading.value) const LinearProgressIndicator(),
        if (controller.historyError.value.isNotEmpty)
          Text((controller.historyError.value).tr),
        TextButton(
          onPressed: controller.refreshHistory,
          child: Text("Refresh my plans".tr),
        ),
        if (controller.purchases.isEmpty && !controller.historyLoading.value)
          Text(
            (controller.customerId() == null
                    ? "Sign in to see your purchases.".tr
                    : "You have no plan purchases yet.".tr)
                .tr,
          ),
        for (final purchase in controller.purchases)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (purchase.name).tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text((purchase.status.toUpperCase()).tr),
                  Text(
                    "@p0 @p1 · @p2 months".trParams({
                      "p0": (purchase.currency.toUpperCase()).toString(),
                      "p1": (purchase.price.toStringAsFixed(2)).toString(),
                      "p2": (purchase.months).toString(),
                    }),
                  ),
                  if (purchase.status == 'pending')
                    Text(
                      "Payment not verified. This plan does not grant access."
                          .tr,
                    ),
                  if (purchase.paidAt != null)
                    Text(
                      "Paid: @p0".trParams({
                        "p0": (_date(context, purchase.paidAt!)).toString(),
                      }),
                    ),
                  if (purchase.startsAt != null)
                    Text(
                      "Starts: @p0".trParams({
                        "p0": (_date(context, purchase.startsAt!)).toString(),
                      }),
                    ),
                  if (purchase.expiresAt != null)
                    Text(
                      "Expires: @p0".trParams({
                        "p0": (_date(context, purchase.expiresAt!)).toString(),
                      }),
                    ),
                ],
              ),
            ),
          ),
      ],
    ),
  );

  String _date(BuildContext context, DateTime date) =>
      MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
}
