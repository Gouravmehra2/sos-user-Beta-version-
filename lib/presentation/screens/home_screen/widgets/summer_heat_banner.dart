import 'package:flutter/material.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';

class SummerHeatBanner extends StatelessWidget {
  final HomeController controller;

  const SummerHeatBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onSummerHeatBannerTapped,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowGrey.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFBB5E), Color(0xFFFFA726)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Service image on right
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Image.asset(
                  'assets/images/onboarding_image_2.png',
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),

              // Overlay gradient for readability
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFBB5E).withValues(alpha: 1.0),
                        const Color(0xFFFFBB5E).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Text content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 130, 14),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beat the',
                            style: AppTextStyle.titleSmallSemiBold.copyWith(
                              color: AppColor.blackShade1,
                            ),
                          ),
                          Text(
                            'Summer Heat',
                            style: AppTextStyle.titleLargeBold.copyWith(
                              color: AppColor.blackShade1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Cooling issues fixed by\nthe professionals.',
                        style: AppTextStyle.bodySmallRegular.copyWith(
                          color: AppColor.blackShade1,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.onSummerHeatBannerTapped,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.blackColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Book Now',
                            style: AppTextStyle.buttonSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
