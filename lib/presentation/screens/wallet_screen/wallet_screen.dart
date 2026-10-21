import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'wallet_controller.dart';

class WalletScreen extends GetView<WalletController> {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Wallet Payment".tr,
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BalanceCard(controller: controller),
          const SizedBox(height: 24),
          _TransactionsSection(controller: controller),
          const SizedBox(height: 24),
          _FeatureCards(),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final WalletController controller;
  const _BalanceCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CURRENT BALANCE".tr,
                style: AppTextStyle.labelSmallRegular.copyWith(
                  color: Colors.white54,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final parts = controller.balance.value
                    .toStringAsFixed(2)
                    .split('.');
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ('\$${parts[0]}').tr,
                        style: AppTextStyle.displayLargeBold.copyWith(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      TextSpan(
                        text: ('.${parts[1]}').tr,
                        style: AppTextStyle.headlineSmallSemiBold.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: controller.goToAddMoney,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "Add Money".tr,
                        style: AppTextStyle.titleSmallSemiBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  final WalletController controller;
  const _TransactionsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wallet Transactions".tr,
              style: AppTextStyle.titleMediumSemiBold.copyWith(
                color: AppColor.blackColor,
              ),
            ),
            Text(
              "home_view_all".tr,
              style: AppTextStyle.titleSmallSemiBold.copyWith(
                color: AppColor.blackColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...controller.transactions.map((tx) => _TransactionTile(tx: tx)),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx['isCredit'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xffDBF4E4)
                  : const Color(0xffEEEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCredit ? AppColor.green2Color : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (tx['title']).tr,
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (tx['sub']).tr,
                  style: AppTextStyle.bodySmallRegular.copyWith(
                    color: AppColor.coolGrayText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            (tx['amount']).tr,
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: isCredit ? AppColor.green2Color : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FeatureCard(
            icon: Icons.verified_user_outlined,
            title: "100% Secure".tr,
            subtitle: "Your money is safe with us".tr,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FeatureCard(
            icon: Icons.history,
            title: "Instant Refunds".tr,
            subtitle: "Refunds are credited instantly".tr,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColor.blackColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            (title).tr,
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.blackShade1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (subtitle).tr,
            style: AppTextStyle.bodySmallRegular.copyWith(
              color: AppColor.coolGrayText,
            ),
          ),
        ],
      ),
    );
  }
}
