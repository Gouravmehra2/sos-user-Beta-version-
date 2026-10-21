import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/payment_screen/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Options".tr,
              style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
            ),
            Text(
              "Booking for Jagriti at CXO Suites, Ground Floor, IT Park".tr,
              style: AppTextStyle.bodySmallRegular.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "To Pay: ".tr,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.blackShade1,
                      ),
                    ),
                    Text(
                      ('\$${controller.total.toStringAsFixed(0)}').tr,
                      style: AppTextStyle.titleSmallSemiBold.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View Invoice".tr,
                    style: AppTextStyle.bodySmallMedium.copyWith(
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionTitle('Recommended Payments'),
                const SizedBox(height: 8),
                _PaymentOptionsList(controller: controller),
                const SizedBox(height: 16),
                _WalletSection(),
                const SizedBox(height: 16),
                _UpiSection(controller: controller),
                const SizedBox(height: 16),
                _CardSection(),
                const SizedBox(height: 16),
                _NetbankingSection(),
                const SizedBox(height: 16),
                _CashOnDelivery(controller: controller),
                const SizedBox(height: 16),
                CommonButton(
                  label: "Confirm & Book".tr,
                  onTap: controller.confirmPayment,
                  backgroundColor: AppColor.blackColor,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Text(
    (title).tr,
    style: AppTextStyle.titleSmallSemiBold.copyWith(
      color: AppColor.blackShade1,
      fontSize: 15,
    ),
  );
}

class _PaymentOptionsList extends StatelessWidget {
  final PaymentController controller;
  const _PaymentOptionsList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = ['Apple Pay UPI', 'BHIM UPI', 'PayPal Payments'];
    return _WhiteCard(
      child: Column(
        children: items.map((e) {
          final isLast = e == items.last;
          return Column(
            children: [
              _PaymentRow(label: e, onTap: () => controller.selectMethod(e)),
              if (!isLast)
                const Divider(height: 1, color: AppColor.lightGreyColor),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  const _PaymentRow({required this.label, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.payment, size: 20, color: AppColor.blackColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                (label).tr,
                style: AppTextStyle.bodyMediumRegular.copyWith(
                  color: AppColor.blackShade1,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: AppColor.coolGrayText,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}

class _WalletSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: ('SOS ').tr,
                style: AppTextStyle.titleSmallSemiBold.copyWith(
                  color: AppColor.blackColor,
                ),
              ),
              TextSpan(
                text: "profile_wallet".tr,
                style: AppTextStyle.titleSmallSemiBold.copyWith(
                  color: AppColor.blackShade1,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _WhiteCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.blackColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ('SOS').tr,
                    style: AppTextStyle.labelSmallMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Unlock SOS Wallet".tr,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  "LINK >".tr,
                  style: AppTextStyle.bodySmallMedium.copyWith(
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UpiSection extends StatelessWidget {
  final PaymentController controller;
  const _UpiSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Pay by UPI'),
        const SizedBox(height: 8),
        _WhiteCard(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_outlined,
                      size: 20,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pay by any UPI app".tr,
                            style: AppTextStyle.bodyMediumRegular.copyWith(
                              color: AppColor.blackShade1,
                            ),
                          ),
                          Text(
                            "Use any UPI app on the phone to pay".tr,
                            style: AppTextStyle.bodySmallRegular.copyWith(
                              color: AppColor.coolGrayText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "LINK >".tr,
                      style: AppTextStyle.bodySmallMedium.copyWith(
                        color: AppColor.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: AppColor.lightGreyColor,
                indent: 14,
                endIndent: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['P', 'B', 'A', 'G', 'P', 'P']
                      .map(
                        (l) => Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              (l).tr,
                              style: AppTextStyle.labelSmallMedium.copyWith(
                                color: AppColor.blackShade1,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(
                height: 1,
                color: AppColor.lightGreyColor,
                indent: 14,
                endIndent: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.qr_code_2,
                      size: 20,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text("Pay via QR Code".tr)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "NEW".tr,
                        style: AppTextStyle.labelSmallMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColor.coolGrayText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Credit & Debit Cards'),
        const SizedBox(height: 8),
        _WhiteCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: AppColor.blackColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add New Card".tr,
                        style: AppTextStyle.bodyMediumRegular.copyWith(
                          color: AppColor.blackColor,
                        ),
                      ),
                      Text(
                        "Visa, Mastercard, Rupay & more".tr,
                        style: AppTextStyle.bodySmallRegular.copyWith(
                          color: AppColor.coolGrayText,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "LINK >".tr,
                  style: AppTextStyle.bodySmallMedium.copyWith(
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NetbankingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final banks = [
      'HDFC\nBank',
      'HSBC\nBank',
      'SBI\nBank',
      'Axis\nBank',
      'ICICI\nBank',
      'IOB\nBank',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Netbanking'),
        const SizedBox(height: 8),
        _WhiteCard(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: banks
                      .map(
                        (b) => Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  (b.split('\n')[0][0]).tr,
                                  style: AppTextStyle.titleSmallSemiBold
                                      .copyWith(color: AppColor.blackColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (b).tr,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.labelSmallRegular.copyWith(
                                color: AppColor.coolGrayText,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor.blackColor,
                        size: 18,
                      ),
                      Text(
                        "View More Bank".tr,
                        style: AppTextStyle.bodySmallMedium.copyWith(
                          color: AppColor.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CashOnDelivery extends StatelessWidget {
  final PaymentController controller;
  const _CashOnDelivery({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Cash on Delivery'),
        const SizedBox(height: 8),
        _WhiteCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.local_atm_outlined,
                  size: 22,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text("Pay by Cash / UPI on Service".tr)),
                Obx(
                  () => Radio<bool>(
                    value: true,
                    groupValue: controller.cashOnDelivery.value,
                    onChanged: (v) => controller.cashOnDelivery.value = true,
                    activeColor: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColor.lightGreyColor),
    ),
    child: child,
  );
}
