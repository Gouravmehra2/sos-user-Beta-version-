import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/custom_search_bar.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/home_header.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/home_section_header.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/popular_services_row.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/service_categories_row.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/need_help_banner.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/special_offer_carousel.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/summer_heat_banner.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/user_stories_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return MyScaffold(
          body: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              gradient: AppColor.homeScreenBackgroundGradient,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.06),
                  // ── Header (greeting + location + icons) ──────────────
                  HomeHeader(controller: controller),
                  const SizedBox(height: 16),
                  // ── Search Bar ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomSearchBar(
                      hintText: 'Search for AC Repair or Plumber',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ── Service Categories ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: HomeSectionHeader(
                      title: 'Service Categories',
                      onViewAll: controller.onViewAllServicesTapped,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ServiceCategoriesRow(controller: controller),
                  const SizedBox(height: 20),
                  // ── Need Help SOS Banner ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: NeedHelpBanner(controller: controller),
                  ),
                  const SizedBox(height: 24),
                  // ── Special Offers ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: HomeSectionHeader(
                      title: 'Special Offers',
                      onViewAll: controller.onViewAllOffersTapped,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SpecialOfferCarousel(controller: controller),

                  const SizedBox(height: 24),

                  // ── Squad Care+ ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: HomeSectionHeader(
                      title: 'Special Offers',
                      onViewAll: controller.onViewAllOffersTapped,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      AppAssets.specialOfferImage,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Popular Services ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: HomeSectionHeader(
                      title: 'Popular Services',
                      onViewAll: controller.onViewAllPopularTapped,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.popularServices.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final service = controller.popularServices[index];

                        return PopularServicesRow(
                          imagePath: service.imagePath,
                          title: service.title,
                          buttonLabel: service.buttonLabel,
                          onBook: () =>
                              controller.onPopularServiceBook(service),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Summer Heat Banner ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SummerHeatBanner(controller: controller),
                  ),

                  const SizedBox(height: 24),

                  // ── User Stories ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: HomeSectionHeader(
                      title: "User's Stories",
                      onViewAll: controller.onViewAllStoriesTapped,
                    ),
                  ),
                  const SizedBox(height: 14),
                  UserStoriesRow(controller: controller),

                  const SizedBox(height: 32),

                  // ── Footer tagline ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NO MORE',
                          style: AppTextStyle.labelSmallMedium.copyWith(
                            color: AppColor.coolGrayText,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Love Your\nLiving',
                          style: AppTextStyle.displayLargeBold.copyWith(
                            color: AppColor.brownAccentPrimary,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We help you live better so you don't have to\nworry about any repairs or installs.",
                          style: AppTextStyle.bodySmallRegular.copyWith(
                            color: AppColor.coolGrayText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
