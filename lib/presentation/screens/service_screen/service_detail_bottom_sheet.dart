import 'package:squadonsite/presentation/screens/book_service_screen/widgets/addon_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

class ServiceDetailBottomSheet extends StatefulWidget {
  final ServiceItem service;

  const ServiceDetailBottomSheet({super.key, required this.service});

  static void show(ServiceItem service) {
    Get.bottomSheet(
      ServiceDetailBottomSheet(service: service),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Prevent the sheet from being dismissed by tapping outside
      // while scrolling, which behaves inconsistently across platforms.
      enableDrag: true,
    );
  }

  @override
  State<ServiceDetailBottomSheet> createState() =>
      _ServiceDetailBottomSheetState();
}

class _ServiceDetailBottomSheetState extends State<ServiceDetailBottomSheet> {
  int? _selectedVariantIndex;
  final Set<String> _selectedAddonIds = {};
  final Map<String, bool> _expandedFaqs = {};

  @override
  void initState() {
    super.initState();
    if (widget.service.hasVariants && widget.service.variants.isNotEmpty) {
      final index = widget.service.variants.indexWhere(
        (variant) => variant.isActive,
      );
      _selectedVariantIndex = index < 0 ? null : index;
    }
  }

  String _formatDuration(int minutes) {
    if (minutes <= 0) return '';
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  String _displayPrice() {
    final s = widget.service;
    final addonPriceInCents = s.addons
        .where(
          (addon) => addon.isActive && _selectedAddonIds.contains(addon.id),
        )
        .fold<int>(
          0,
          (total, addon) =>
              total + (addon.price > 0 ? (addon.price * 100).round() : 0),
        );

    if (s.hasVariants && s.variants.isNotEmpty) {
      if (_selectedVariantIndex != null) {
        final priceInCents =
            (s.variants[_selectedVariantIndex!].offerPrice * 100).round() +
            addonPriceInCents;
        return _formatPrice(priceInCents);
      }
      if (s.priceMin > 0 && s.priceMax > 0) {
        final minPrice = (s.priceMin * 100).round() + addonPriceInCents;
        final maxPrice = (s.priceMax * 100).round() + addonPriceInCents;
        return minPrice == maxPrice
            ? _formatPrice(minPrice)
            : '${_formatPrice(minPrice)} – ${_formatPrice(maxPrice)}';
      }
    }
    if (s.offerPrice > 0 || addonPriceInCents > 0) {
      return _formatPrice((s.offerPrice * 100).round() + addonPriceInCents);
    }
    return '';
  }

  String _formatPrice(int priceInCents) {
    final dollars = priceInCents / 100;
    return priceInCents % 100 == 0
        ? '\$${priceInCents ~/ 100}'
        : '\$${dollars.toStringAsFixed(2)}';
  }

  int _displayDuration() {
    if (widget.service.hasVariants &&
        widget.service.variants.isNotEmpty &&
        _selectedVariantIndex != null) {
      return widget.service.variants[_selectedVariantIndex!].duration;
    }
    return widget.service.serviceDuration;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sh = mq.size.height;
    final sw = mq.size.width;
    // Account for the system bottom bar (Android nav bar / iOS home indicator)
    // so the sheet and its footer always respect safe areas on both platforms.
    final bottomInset = mq.padding.bottom;

    final s = widget.service;
    final imageUrl = s.featuredImage.isNotEmpty
        ? '${ApiEndpoints.imageUrl}${s.featuredImage}'
        : null;

    return Container(
      // Use 92% of screen height minus the top safe area so the sheet
      // never goes behind the status bar on either platform.
      height: sh * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.lightGreyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Hero header ──────────────────────────────────────────────────
          _buildHeader(context, sw, imageUrl, s),

          // ── Scrollable body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sw * 0.045, 20, sw * 0.045, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Variants
                  if (s.hasVariants && s.variants.isNotEmpty) ...[
                    _sectionTitle('Choose Package'),
                    const SizedBox(height: 12),
                    _buildVariants(sw, s.variants),
                    _sectionDivider(),
                  ],

                  // Short bullet descriptions
                  if (s.shortDescription.isNotEmpty) ...[
                    _sectionTitle("What's Included"),
                    const SizedBox(height: 10),
                    _buildIncludedItems(s.includedItems),
                    _sectionDivider(),
                  ],

                  // About
                  if (s.longDescription.isNotEmpty) ...[
                    _sectionTitle('About This Service'),
                    const SizedBox(height: 10),
                    Text(
                      (s.longDescription).tr,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.coolGrayText,
                        height: 1.7,
                      ),
                    ),
                    _sectionDivider(),
                  ],

                  // Process Steps
                  if (s.processSteps.isNotEmpty) ...[
                    _sectionTitle('How It Works'),
                    const SizedBox(height: 12),
                    _buildProcessSteps(s.processSteps),
                    _sectionDivider(),
                  ],

                  // Excluded items
                  if (s.excludedItems.isNotEmpty) ...[
                    _sectionTitle('Not Included'),
                    const SizedBox(height: 10),
                    _buildExcludedItems(s.excludedItems),
                    _sectionDivider(),
                  ],

                  // Requirements
                  if (s.requirements.isNotEmpty) ...[
                    _sectionTitle('Requirements'),
                    const SizedBox(height: 10),
                    _buildRequirements(s.requirements),
                    _sectionDivider(),
                  ],

                  // Add-ons
                  if (s.addons.isNotEmpty) ...[
                    _sectionTitle('Available Add-ons'),
                    const SizedBox(height: 12),
                    _buildAddons(s.addons),
                    _sectionDivider(),
                  ],

                  // Tools
                  if (s.tools.isNotEmpty) ...[
                    _sectionTitle('Tools & Equipment'),
                    const SizedBox(height: 12),
                    _buildTools(s.tools),
                    _sectionDivider(),
                  ],

                  // FAQs
                  if (s.faqs.isNotEmpty) ...[
                    _sectionTitle('FAQs'),
                    const SizedBox(height: 8),
                    _buildFaqs(s.faqs),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),

          // ── Sticky Book Now footer ────────────────────────────────────────
          _buildFooter(sw, bottomInset),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    double sw,
    String? imageUrl,
    ServiceItem s,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(sw * 0.045, 8, sw * 0.045, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: sw * 0.30,
                        height: sw * 0.26,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) =>
                            _imagePlaceholder(sw),
                      )
                    : _imagePlaceholder(sw),
              ),
              SizedBox(width: sw * 0.04),
              // Title + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (s.name).tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.titleLargeBold.copyWith(
                        color: AppColor.blackShade1,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Rating row
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 4,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          (s.ratingsAverage.toStringAsFixed(1)).tr,
                          style: AppTextStyle.bodySmallMedium.copyWith(
                            color: AppColor.blackShade1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(@p0 reviews)".trParams({
                            "p0": (s.ratingsQuantity).toString(),
                          }),
                          style: AppTextStyle.bodySmallRegular.copyWith(
                            color: AppColor.coolGrayText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Price
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 4,
                      children: [
                        Text(
                          (_displayPrice()).tr,
                          style: AppTextStyle.headlineMediumSemiBold.copyWith(
                            color: AppColor.blackColor,
                          ),
                        ),
                        if (_displayDuration() > 0)
                          Text(
                            ('/${_formatDuration(_displayDuration())}').tr,
                            style: AppTextStyle.headlineMediumSemiBold.copyWith(
                              color: AppColor.coolGrayText,
                              fontSize: 15,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Variants ──────────────────────────────────────────────────────────────

  Widget _buildVariants(double sw, List<VariantItem> variants) {
    return Column(
      children: List.generate(variants.length, (i) {
        final v = variants[i];
        final selected = _selectedVariantIndex == i;
        final hasDiscount = v.discountPercentage > 0;

        return GestureDetector(
          onTap: v.isActive
              ? () => setState(() => _selectedVariantIndex = i)
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? AppColor.blackColor : Colors.white,
              border: Border.all(
                color: selected ? AppColor.blackColor : AppColor.lightGreyColor,
                width: selected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Radio indicator
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.white : AppColor.coolGrayText,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (v.name).tr,
                        style: AppTextStyle.titleSmallSemiBold.copyWith(
                          color: selected ? Colors.white : AppColor.blackShade1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (v.duration > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              size: 11,
                              color: AppColor.coolGrayText,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              (_formatDuration(v.duration)).tr,
                              style: AppTextStyle.labelSmallRegular.copyWith(
                                color: selected
                                    ? Colors.white60
                                    : AppColor.coolGrayText,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Price block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ('\$${v.offerPrice}').tr,
                      style: AppTextStyle.titleSmallSemiBold.copyWith(
                        color: selected ? Colors.white : AppColor.blackColor,
                        fontSize: 15,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(height: 2),
                      Text(
                        ('\$${v.actualPrice}').tr,
                        style: AppTextStyle.labelSmallRegular.copyWith(
                          color: selected
                              ? Colors.white60
                              : AppColor.coolGrayText,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    if (hasDiscount)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.15)
                              : AppColor.lightGreen1Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "@p0% off".trParams({
                            "p0": (v.discountPercentage.toInt()).toString(),
                          }),
                          style: AppTextStyle.labelSmallMedium.copyWith(
                            color: selected
                                ? Colors.white
                                : AppColor.green2Color,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Included items ────────────────────────────────────────────────────────

  Widget _buildIncludedItems(List<IncludedItem> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreen1Color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 11,
                      color: AppColor.green2Color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (item.title).tr,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.blackShade1,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Excluded items ────────────────────────────────────────────────────────

  Widget _buildExcludedItems(List<IncludedItem> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEEEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 11,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (item.title).tr,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.coolGrayText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Process Steps ─────────────────────────────────────────────────────────

  Widget _buildProcessSteps(List<ProcessStep> steps) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number + connector line
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColor.blackColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        ('${step.stepNumber}').tr,
                        style: AppTextStyle.labelMediumSemiBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1.5,
                        color: AppColor.lightGreyColor,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (step.title).tr,
                        style: AppTextStyle.titleSmallSemiBold.copyWith(
                          color: AppColor.blackShade1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (step.description).tr,
                        style: AppTextStyle.bodyMediumRegular.copyWith(
                          color: AppColor.coolGrayText,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── Requirements ──────────────────────────────────────────────────────────

  Widget _buildRequirements(List<RequirementItem> reqs) {
    return Column(
      children: reqs
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEF2FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 11,
                      color: Color(0xFF4F6EF7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (r.title).tr,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.blackShade1,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Add-ons ───────────────────────────────────────────────────────────────

  Widget _buildAddons(List<AddonItem> addons) => AddonSelector(
    addons: addons,
    selectedIds: _selectedAddonIds,
    onToggle: (addon) => setState(() {
      if (!_selectedAddonIds.add(addon.id)) _selectedAddonIds.remove(addon.id);
    }),
  );

  // ── Tools ─────────────────────────────────────────────────────────────────

  Widget _buildTools(List<ServiceToolItem> tools) {
    return Column(
      children: tools.map((tool) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColor.lightGreyColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.neutral1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.build_outlined,
                  size: 18,
                  color: AppColor.darkGray,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (tool.name).tr,
                      style: AppTextStyle.titleSmallSemiBold.copyWith(
                        color: AppColor.blackShade1,
                      ),
                    ),
                    if (tool.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        (tool.description).tr,
                        style: AppTextStyle.bodySmallRegular.copyWith(
                          color: AppColor.coolGrayText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── FAQs ──────────────────────────────────────────────────────────────────

  Widget _buildFaqs(List<FaqItem> faqs) {
    return Column(
      children: faqs.map((faq) {
        final expanded = _expandedFaqs[faq.question] ?? false;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColor.lightGreyColor),
            borderRadius: BorderRadius.circular(12),
          ),
          // Use ExpansionTileTheme to neutralise Material default
          // padding/divider differences between Android and iOS.
          child: ExpansionTileTheme(
            data: const ExpansionTileThemeData(
              // Remove the top/bottom borders Flutter draws by default.
              collapsedShape: RoundedRectangleBorder(side: BorderSide.none),
              shape: RoundedRectangleBorder(side: BorderSide.none),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 2,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              // Suppress the default top/bottom dividers that Material adds.
              collapsedBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              onExpansionChanged: (val) =>
                  setState(() => _expandedFaqs[faq.question] = val),
              trailing: AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColor.coolGrayText,
                  size: 20,
                ),
              ),
              title: Text(
                (faq.question).tr,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColor.blackShade1,
                ),
              ),
              children: [
                Text(
                  (faq.answer).tr,
                  style: AppTextStyle.bodyMediumRegular.copyWith(
                    color: AppColor.coolGrayText,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter(double sw, double bottomInset) {
    final s = widget.service;
    final price = _displayPrice();
    final duration = _displayDuration();

    return Container(
      // Add the system bottom inset so the footer clears the Android nav bar
      // and the iOS home indicator on both platforms consistently.
      padding: EdgeInsets.fromLTRB(
        sw * 0.045,
        12,
        sw * 0.045,
        12 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColor.lightGreyColor)),
      ),
      child: Row(
        children: [
          // Price + duration summary
          if (price.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 4,
                    children: [
                      Text(
                        (price).tr,
                        style: AppTextStyle.headlineSmallSemiBold.copyWith(
                          color: AppColor.blackColor,
                        ),
                      ),
                      if (duration > 0)
                        Text(
                          ('/${_formatDuration(duration)}').tr,
                          style: AppTextStyle.headlineSmallSemiBold.copyWith(
                            color: AppColor.coolGrayText,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          // Book Now button
          Expanded(
            flex: price.isNotEmpty ? 2 : 3,
            child: CommonButton(
              label: "home_offer_book_now".tr,
              onTap: () {
                Get.back();
                Get.toNamed(
                  AppRoutes.bookServiceScreen,
                  arguments: BookingSelection(
                    service: s,
                    variantId: _selectedVariantIndex == null
                        ? null
                        : s.variants[_selectedVariantIndex!].id,
                    addonIds: Set.of(_selectedAddonIds),
                  ),
                );
              },
              backgroundColor: AppColor.blackColor,
              foregroundColor: Colors.white,
              trailingIcon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      (title).tr,
      style: AppTextStyle.titleMediumSemiBold.copyWith(
        color: AppColor.blackShade1,
      ),
    );
  }

  Widget _sectionDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(color: AppColor.lightGreyColor, height: 1),
    );
  }

  Widget _imagePlaceholder(double sw) {
    return Container(
      width: sw * 0.30,
      height: sw * 0.26,
      decoration: BoxDecoration(
        color: AppColor.neutral1,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColor.coolGrayText,
          size: 36,
        ),
      ),
    );
  }
}
