import 'dart:math' as math;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/common_widgets/app_network_image.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_detail_bottom_sheet.dart';

class PopularServicesCarousel extends StatefulWidget {
  final HomeController controller;

  const PopularServicesCarousel({super.key, required this.controller});

  @override
  State<PopularServicesCarousel> createState() =>
      _PopularServicesCarouselState();
}

class _PopularServicesCarouselState extends State<PopularServicesCarousel> {
  int _currentIndex = 0;
  final _carousel = CarouselSliderController();

  @override
  Widget build(BuildContext context) => Obx(() {
    final services = widget.controller.featuredServices.toList();
    if (widget.controller.isLoadingFeatured.value && services.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
        ),
      );
    }
    if (services.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final fraction = services.length == 1
            ? 1.0
            : width < 500
            ? .88
            : 380 / width;
        final scale = MediaQuery.textScalerOf(context);
        // Size the cards to their titles and actions without a blank price area.
        final titleWidth =
            width * fraction - (services.length == 1 ? 40 : 12) - 32;
        var titleHeight = 0.0;
        for (final service in services) {
          final painter = TextPainter(
            text: TextSpan(
              text:
                  (service.name.isEmpty ? "Home service".tr : service.name).tr,
              style: const TextStyle(
                fontSize: 18,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
            maxLines: 2,
            ellipsis: '…',
            textDirection: Directionality.of(context),
            textScaler: scale,
          )..layout(maxWidth: math.max(1, titleWidth));
          titleHeight = math.max(titleHeight, painter.height);
          painter.dispose();
        }
        var actionsHeight = 0.0;
        for (final label in ['Book now', 'View details']) {
          final painter = TextPainter(
            text: TextSpan(
              text: (label).tr,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontSize: 14, height: 1.2),
            ),
            textDirection: Directionality.of(context),
            textScaler: scale,
          )..layout(maxWidth: math.max(1, titleWidth - 32));
          actionsHeight += math.max(48.0, painter.height + 24);
          painter.dispose();
        }
        final height = 160 + 8 + 32 + titleHeight + 12 + actionsHeight;
        final active = _currentIndex.clamp(0, services.length - 1);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider.builder(
              carouselController: _carousel,
              itemCount: services.length,
              options: CarouselOptions(
                autoPlay: true,
                height: height,
                viewportFraction: fraction,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                padEnds: true,
                onPageChanged: (index, _) {
                  setState(() => _currentIndex = index);
                  if (index >= services.length - 2) {
                    widget.controller.loadMoreFeaturedServices();
                  }
                },
              ),
              itemBuilder: (context, index, realIndex) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: services.length == 1 ? 20 : 6,
                  vertical: 4,
                ),
                child: _ServiceCard(
                  key: ValueKey(services[index].id),
                  service: services[index],
                  controller: widget.controller,
                ),
              ),
            ),
            if (services.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(services.length, (index) {
                    final bool isActive = active == index;

                    return GestureDetector(
                      onTap: () {
                        _carousel.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF1F1F1F)
                              : const Color(0xFFD6D9DB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  });
}

class _ServiceCard extends StatefulWidget {
  final FeaturedServiceItem service;
  final HomeController controller;

  const _ServiceCard({
    super.key,
    required this.service,
    required this.controller,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  String? _opening;

  Future<void> _open({required bool book}) async {
    if (_opening != null) return;
    setState(() => _opening = book ? 'book' : 'details');
    try {
      final service = await widget.controller.loadFeaturedService(
        widget.service,
      );
      if (!mounted) return;
      if (book) {
        Get.toNamed(AppRoutes.bookServiceScreen, arguments: service);
      } else {
        ServiceDetailBottomSheet.show(service);
      }
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        "Unable to load service".tr,
        "Unable to load this service. Please try again.".tr,
        mainButton: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Get.theme.brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () {
            if (mounted) _open(book: book);
          },
          child: Text("Retry".tr),
        ),
      );
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final path = service.featuredImage;
    final imageUrl = path.startsWith('http://') || path.startsWith('https://')
        ? path
        : '${ApiEndpoints.imageUrl}${path.replaceFirst(RegExp(r'^/+'), '')}';
    final placeholder = Container(
      color: const Color(0xFFF0F3F4),
      child: const Center(
        child: Icon(
          Icons.home_repair_service_outlined,
          size: 42,
          color: Color(0xFF879398),
        ),
      ),
    );
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE5EAED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (path.isEmpty)
                  placeholder
                else
                  AppNetworkImage(
                    url: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: placeholder,
                    errorWidget: placeholder,
                  ),
                if (service.rating > 0)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFC18B24),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (service.rating.toStringAsFixed(1)).tr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (service.name.isEmpty ? "Home service".tr : service.name)
                        .tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF182025),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _opening == null
                          ? () => _open(book: true)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Text(
                        (_opening == 'book' ? "Loading…".tr : "Book now".tr).tr,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _opening == null
                          ? () => _open(book: false)
                          : null,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF182025),
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: Text(
                        (_opening == 'details'
                                ? "Loading…".tr
                                : "View details".tr)
                            .tr,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
