import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/app_network_image.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/home_header.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/home_section_header.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/popular_services_row.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/need_help_banner.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/user_stories_row.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Single source of truth for horizontal page padding
  static const double _hPad = 16.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return MyScaffold(
            body: Container(
              height: Get.height,
              width: Get.width,
              decoration: const BoxDecoration(
                gradient: AppColor.homeScreenBackgroundGradient,
              ),
              child: Stack(
                children: [
                  // ── Scrollable content ───────────────────────────────
                  RefreshIndicator(
                    onRefresh: () => controller.refreshData(),
                    color: AppColor.blackColor,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.depth == 0 &&
                            notification is ScrollUpdateNotification &&
                            notification.scrollDelta != 0) {
                          controller.hideSearchSuggestions();
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                bottom: 20,
                                top: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).padding.top - 20,
                                  ),
                                  HomeHeader(controller: controller),

                                  const SizedBox(height: 16),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: _hPad,
                                    ),
                                    child: _buildServiceFilterRow(
                                      context,
                                      controller,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _hPad,
                              ),
                              child: HomeSectionHeader(
                                title: 'home_section_service_categories'.tr,
                                onViewAll: () {
                                  Get.toNamed(AppRoutes.homeServicesScreen);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _hPad,
                              ),
                              child: NeedHelpBanner(controller: controller),
                            ),
                            const SizedBox(height: 20),
                            PopularServicesCarousel(controller: controller),
                            const SizedBox(height: 20),
                            UserStoriesRow(controller: controller),
                            const SizedBox(height: 28),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _hPad,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 2,
                                        color: AppColor.blackColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'HEY, ${controller.userName.toUpperCase()}!',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            height: 1.4,
                                            color: AppColor.coolGrayText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  const AnimatedServiceHeading(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ), // RefreshIndicator
                  // ── Search dropdown overlay (floats over content) ────
                  Obx(() {
                    if (!controller.isSearchMode.value ||
                        !controller.showSearchSuggestions.value)
                      return const SizedBox.shrink();
                    // Top offset: status bar + header height + search bar offset
                    final topOffset =
                        MediaQuery.of(context).padding.top +
                            16 +
                            56 +
                            56 +
                            35.0;
                    return Positioned(
                      top: topOffset,
                      left: _hPad,
                      right: _hPad,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: controller.isLoadingSearch.value
                            ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                            : controller.searchResults.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No services found.',
                            style: AppTextStyle.bodyMediumRegular
                                .copyWith(color: AppColor.coolGrayText),
                          ),
                        )
                            : ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 280,
                          ),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.extentAfter < 80) {
                                controller.loadMoreSearchResults();
                              }
                              return false;
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                              controller.searchResults.length +
                                  (controller.isLoadingMoreSearch.value
                                      ? 1
                                      : 0),
                              separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                              itemBuilder: (_, i) {
                                if (i >=
                                    controller.searchResults.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                                final s = controller.searchResults[i];
                                return _SearchResultTile(
                                  service: s,
                                  onBook: () {
                                    controller.clearSearch();
                                    Get.toNamed(
                                      AppRoutes.bookServiceScreen,
                                      arguments: s,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceFilterRow(
      BuildContext context,
      HomeController controller,
      )
  {
    final sw = MediaQuery.sizeOf(context).width;
    final bool isSmallScreen = sw < 360;
    final double fontSize = isSmallScreen ? 13 : 14;
    final double fieldHeight =
        24 + MediaQuery.textScalerOf(context).scale(fontSize) * 1.5;
    final double borderRadius = fieldHeight / 2;

    final fieldDecoration = BoxDecoration(
      color: Colors.white.withValues(alpha: 0.20),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.4),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColor.blackColor.withValues(alpha: 0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final searchField = Expanded(
      child: Container(
        height: fieldHeight,
        decoration: fieldDecoration,
        child: Obx(
              () => TextField(
            controller: controller.searchController,
            cursorColor: Colors.white,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onTap: controller.showSearchSuggestionsAgain,
            onChanged: controller.onSearchChanged,
            style: AppTextStyle.bodyLargeMedium.copyWith(
              color: Colors.white,
              fontSize: fontSize,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search service & book your service',
              hintStyle: AppTextStyle.bodyLargeMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: fontSize,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: isSmallScreen ? 19 : 20,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 46,
                minHeight: fieldHeight,
              ),
              suffixIcon: controller.isSearchMode.value
                  ? GestureDetector(
                onTap: controller.clearSearch,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
              )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [searchField],
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onBook;

  const _SearchResultTile({required this.service, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.featuredImage.isNotEmpty
        ? '${ApiEndpoints.imageUrl}${service.featuredImage}'
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          AppNetworkImage(
            url: imageUrl,
            width: 52,
            height: 52,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColor.blackShade1,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onBook,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColor.blackColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'BOOK',
                style: AppTextStyle.labelSmallMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AnimatedServiceHeading extends StatefulWidget {
  const AnimatedServiceHeading({super.key});

  @override
  State<AnimatedServiceHeading> createState() =>
      _AnimatedServiceHeadingState();
}

class _AnimatedServiceHeadingState extends State<AnimatedServiceHeading>
    with SingleTickerProviderStateMixin {
  static const List<List<String>> _messages = [
    ['Love Your', 'Living'],
    ['Expert Home', 'Repair Services'],
    ['Trusted', 'Technicians'],
    ['Quality Service,', 'Every Time'],
    ['Your Home,', 'Our Care'],
  ];

  int _currentIndex = 0;
  late final AnimationController _controller;
  late final Animation<Offset> _firstLineAnimation;
  late final Animation<Offset> _secondLineAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _firstLineAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _secondLineAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
    _startTextRotation();
  }

  Future<void> _startTextRotation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return;

      // Finish the current text's exit before changing the content.
      await _controller.reverse();

      if (!mounted) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % _messages.length;
      });

      await _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lines = _messages[_currentIndex];

    final firstStyle = AppTextStyle.displayHeroExtraBold.copyWith(
      color: const Color(0xFF1A1A1A),
      fontSize: 42,
      height: 1.08,
      letterSpacing: -1.5,
    );

    final secondStyle = AppTextStyle.displayHeroExtraBold.copyWith(
      color: AppColor.blackColor,
      fontSize: 42,
      height: 1.08,
      letterSpacing: -1.5,
    );

    return ClipRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // First line: enters from left to right.
          SlideTransition(
            position: _firstLineAnimation,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                lines[0],
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: firstStyle,
              ),
            ),
          ),

          // Second line: enters from bottom to top.
          SlideTransition(
            position: _secondLineAnimation,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                lines[1],
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: secondStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






