import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/app_network_image.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_controller.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_detail_bottom_sheet.dart';

class ServiceScreen extends GetView<ServiceController> {
  ServiceScreen({super.key}) {
    if (!Get.isRegistered<ServiceController>()) {
      Get.put(ServiceController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final railWidth = sw * 0.22;

    return MyScaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          (controller.categoryTitle).tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingSubcategories.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            _LeftCategoryRail(controller: controller, width: railWidth),
            Expanded(child: _RightServiceList(controller: controller)),
          ],
        );
      }),
    );
  }
}

class _LeftCategoryRail extends StatelessWidget {
  final ServiceController controller;
  final double width;

  const _LeftCategoryRail({required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: const Color(0xff111111).withValues(alpha: 0.07),
            width: 2.0,
          ),
        ),
      ),
      child: Obx(() {
        final selected = controller.selectedIndex.value;
        final subs = controller.subcategories;
        return ListView.separated(
          controller: controller.leftScrollController,
          itemCount:
              subs.length +
              (controller.isLoadingMoreSubcategories.value ? 1 : 0),
          separatorBuilder: (_, __) => Divider(
            color: const Color(0xff111111).withValues(alpha: 0.07),
            thickness: 2.0,
            height: 2,
          ),
          itemBuilder: (_, i) {
            if (i >= subs.length) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final isSelected = selected == i;
            return GestureDetector(
              onTap: () => controller.onCategoryTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                color: isSelected ? Colors.white : Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 6,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isSelected ? null : Colors.white,
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  const Color(
                                    0xffF8F4EE,
                                  ).withValues(alpha: 0.0),
                                  const Color(
                                    0xffC3C2BF,
                                  ).withValues(alpha: 0.50),
                                  const Color(0xffAFAFAF),
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(5),
                      child: _SubcategoryIcon(
                        iconPath: subs[i].icon,
                        isSelected: isSelected,
                      ),
                    ),
                    // const SizedBox(height: 3),
                    Text(
                      (subs[i].name).tr,
                      style: AppTextStyle.labelSmallRegular.copyWith(
                        color: isSelected
                            ? AppColor.blackColor
                            : AppColor.coolGrayText,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _SubcategoryIcon extends StatelessWidget {
  final String iconPath;
  final bool isSelected;

  const _SubcategoryIcon({required this.iconPath, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (iconPath.isEmpty) {
      return Icon(
        Icons.miscellaneous_services_outlined,
        size: 30,
        color: isSelected ? AppColor.blackColor : AppColor.coolGrayText,
      );
    }

    final url = '${ApiEndpoints.imageUrl}$iconPath';
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(url, height: 32, width: 32, fit: BoxFit.contain),
        Transform.translate(
          offset: const Offset(0.5, 0),
          child: Image.network(url, height: 32, width: 32, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

class _RightServiceList extends StatelessWidget {
  final ServiceController controller;

  const _RightServiceList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.sizeOf(context).width * 0.03;

    return Obx(() {
      if (controller.isLoadingServices.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final services = controller.services;
      if (services.isEmpty) {
        return Center(
          child: Text(
            "No services available.".tr,
            style: AppTextStyle.bodyMediumRegular.copyWith(
              color: AppColor.coolGrayText,
            ),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: Colors.black,
        child: CustomScrollView(
          controller: controller.rightScrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns =
                      constraints.crossAxisExtent < 300 ||
                          MediaQuery.textScalerOf(context).scale(13) > 19.5
                      ? 1
                      : 2;
                  return SliverList.builder(
                    itemCount: (services.length / columns).ceil(),
                    itemBuilder: (context, row) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var column = 0; column < columns; column++) ...[
                            if (column > 0) const SizedBox(width: 5),
                            Expanded(
                              child: row * columns + column < services.length
                                  ? _ServiceCard(
                                      service: services[row * columns + column],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (controller.isLoadingMoreServices.value)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: _SuggestServiceBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      );
    });
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.featuredImage.isNotEmpty
        ? '${ApiEndpoints.imageUrl}${service.featuredImage}'
        : null;

    return GestureDetector(
      onTap: () => ServiceDetailBottomSheet.show(service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffE6E6E6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: imageUrl != null
                      ? AppNetworkImage(url: imageUrl, fit: BoxFit.cover)
                      : _imagePlaceholder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                (service.name).tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.titleSmallSemiBold.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                "Starting From".tr,
                style: AppTextStyle.labelSmallRegular.copyWith(
                  fontSize: 10,
                  color: const Color(0xff000000).withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                ('\$${service.hasVariants ? service.priceMin : service.offerPrice}')
                    .tr,
                style: AppTextStyle.titleLargeBold.copyWith(
                  fontSize: 13,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 4),
              if (service.ratingsQuantity != 0)
                Row(
                  children: [
                    const Icon(Icons.star, size: 13, color: AppColor.darkGray),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        "@p0 (@p1 Reviews)".trParams({
                          "p0": (service.ratingsAverage).toString(),
                          "p1": (service.ratingsQuantity).toString(),
                        }),
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.labelSmallRegular.copyWith(
                          fontSize: 10,
                          color: const Color(0xff000000).withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoutes.bookServiceScreen,
                  arguments: service,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColor.blackColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "BOOK NOW".tr,
                      style: AppTextStyle.buttonLarge.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
    color: Colors.grey.shade200,
    child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
  );
}

class _SuggestServiceBanner extends StatelessWidget {
  const _SuggestServiceBanner();

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.sizeOf(context).width * 0.06;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 32, height: 1, color: AppColor.coolGrayText),
              const SizedBox(width: 8),
              Text(
                "HEY!".tr,
                style: AppTextStyle.labelSmallMedium.copyWith(
                  color: AppColor.coolGrayText,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: AppTextStyle.displayMediumBold.copyWith(
                color: AppColor.coolGrayText,
              ),
              children: [
                TextSpan(text: "Didn't find\nwhat you were\n".tr),
                TextSpan(
                  text: "Looking for?".tr,
                  style: AppTextStyle.displayMediumBold.copyWith(
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Suggest us a service & we'll look into it".tr,
            style: AppTextStyle.bodyMediumRegular.copyWith(
              color: AppColor.coolGrayText,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColor.blackColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Suggest us a Service".tr,
              style: AppTextStyle.bodyMediumMedium.copyWith(
                color: AppColor.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
