import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';

class BenefitsBottomSheet extends StatelessWidget {
  const BenefitsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: AppColor.shadowGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.neutral1,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColor.blackColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.blackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Best deal',
                            style: AppTextStyle.labelSmallMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Pro SOS Plan',
                          style: AppTextStyle.headlineLargeBold.copyWith(
                            color: AppColor.blackShade1,
                            fontSize: 42,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Covers 3 Devices - Laptops, Desktops,\nPrinters, Phones etc.',
                          style: AppTextStyle.bodyLargeRegular.copyWith(
                            color: AppColor.blackShade1,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Text(
                              '\$1,725',
                              style: AppTextStyle.headlineLargeBold.copyWith(
                                color: AppColor.blackShade1,
                                fontSize: 52,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'billed',
                                  style: AppTextStyle.bodyLargeRegular.copyWith(
                                    color: AppColor.blackShade1,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'annually',
                                  style: AppTextStyle.bodyLargeRegular.copyWith(
                                    color: AppColor.blackShade1,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$172.5',
                              style: AppTextStyle.headlineLargeBold.copyWith(
                                color: AppColor.blackShade1,
                                fontSize: 52,
                              ),
                            ),
                            Text(
                              'per month',
                              style: AppTextStyle.bodyLargeRegular.copyWith(
                                color: AppColor.blackShade1,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Text(
                          'This includes:',
                          style: AppTextStyle.headlineSmallSemiBold.copyWith(
                            color: AppColor.blackShade1,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _BenefitRow(
                          text: 'Includes Security – 5 Devices.',
                        ),
                        const _BenefitRow(
                          text: 'Covers Printer, Modem, Router.',
                        ),
                        const _BenefitRow(text: 'Carbonite Data Backup.'),
                        const _BenefitRow(text: '8 Tickets - 2/Quarter.'),
                        const _BenefitRow(text: '1 Onboarding Non-Refundable.'),
                        const _BenefitRow(text: 'Support. EST 8 AM – EST 8 PM'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(72),
                            backgroundColor: AppColor.blackColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Subscribe Now',
                            style: AppTextStyle.headlineSmallSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String text;

  const _BenefitRow({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle,
              color: AppColor.blackColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.bodyLargeRegular.copyWith(
                color: AppColor.blackShade1,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
