import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/social_login_button.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Available height the sheet can use
        final availableHeight = constraints.maxHeight;

        // Proportional gap — shrinks on small screens, caps on large ones
        final gap = (availableHeight * 0.018).clamp(6.0, 16.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ───────────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(top: gap, bottom: gap),
                decoration: BoxDecoration(
                  color: AppColor.shadowGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Logo ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColor.neutral1,
                shape: BoxShape.circle,
              ),
              child: Text(
                'S',
                style: AppTextStyle.headlineLargeBold.copyWith(
                  color: AppColor.blackShade1,
                ),
              ),
            ),

            SizedBox(height: gap),

            // ── Headline ──────────────────────────────────────────────────
            Text(
              'Explore Now',
              style: AppTextStyle.displayMediumBold.copyWith(
                color: AppColor.blackShade1,
              ),
            ),

            SizedBox(height: gap * 0.5),

            // ── Sub-headline ──────────────────────────────────────────────
            Text(
              'Book trusted technicians and\nprofessional home services in minutes.',
              style: AppTextStyle.bodyLargeRegular.copyWith(
                color: AppColor.coolGrayText,
              ),
            ),

            SizedBox(height: gap * 1.5),

            // ── Guest ─────────────────────────────────────────────────────
            CommonButton(
              label: 'Login as Guest',
              onTap: () =>Get.toNamed(AppRoutes.locationPermissionScreen),
              backgroundColor: AppColor.blackColor,
              foregroundColor: Colors.white,
            ),

            SizedBox(height: gap),

            // ── Phone ─────────────────────────────────────────────────────
            CommonButton(
              backgroundColor: AppColor.shadowGrey,
              foregroundColor: AppColor.blackColor,
              label: 'Continue with Phone',
              onTap: (){
                Get.toNamed(AppRoutes.loginScreen);
              },
              leadingIcon: const Icon(
                Icons.phone_outlined,
                color: AppColor.blackColor,
                size: 20,
              ),
            ),

            SizedBox(height: gap),

            // ── Email ─────────────────────────────────────────────────────
            CommonButton(
              backgroundColor: AppColor.shadowGrey,
              foregroundColor: AppColor.blackColor,
              label: 'Continue with Email',
              onTap: () {
                Get.toNamed(AppRoutes.emailLoginScreen);
              },
              leadingIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColor.blackColor,
                size: 20,
              ),
            ),

            SizedBox(height: gap),

            // ── Social row ────────────────────────────────────────────────
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: SocialLoginButton(
                    onTap: () {},
                    icon:Image.asset(AppAssets.appleImage,height: 20,),
                    backgroundColor: AppColor.shadowGrey,
                    border: Border.all(color: Colors.transparent),
                  ),
                ),
                Expanded(
                  child: SocialLoginButton(
                    onTap: () {
                      SocialAuthService().signInWithGoogle();
                    },
                    icon: Image.asset(AppAssets.googleImage,height: 20,color: Colors.black,),
                    backgroundColor: AppColor.shadowGrey,
                    border: Border.all(color: Colors.transparent),
                  ),
                ),
              ],
            ),

            SizedBox(height: gap),
          ],
        ).paddingSymmetric(horizontal: 20);
      },
    );
  }
}
