import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/app_network_image.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

class AddonSelector extends StatelessWidget {
  const AddonSelector({
    super.key,
    required this.addons,
    required this.selectedIds,
    required this.onToggle,
    this.enabled = true,
  });

  final List<AddonItem> addons;
  final Set<String> selectedIds;
  final ValueChanged<AddonItem> onToggle;
  final bool enabled;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final addon in addons.where((a) => a.isActive && a.id.isNotEmpty))
          _AddonCard(
            addon: addon,
            selected: selectedIds.contains(addon.id),
            enabled: enabled,
            onToggle: onToggle,
          ),
      ],
    ),
  );
}

/// Extracted into its own widget so the selected/enabled state can be
/// read cleanly and the toggle button is a plain [GestureDetector]-based
/// container — identical on Android and iOS.
class _AddonCard extends StatelessWidget {
  const _AddonCard({
    required this.addon,
    required this.selected,
    required this.enabled,
    required this.onToggle,
  });

  final AddonItem addon;
  final bool selected;
  final bool enabled;
  final ValueChanged<AddonItem> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColor.blackColor : AppColor.lightGreyColor,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
          if (addon.image.isNotEmpty) ...[
            AppNetworkImage(
              url: addon.image.startsWith('http')
                  ? addon.image
                  : '${ApiEndpoints.imageUrl}${addon.image}',
              width: 176,
              height: 90,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
          ],

          // Name
          Text(
            addon.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.blackShade1,
            ),
          ),

          // Description
          if (addon.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            ReadMoreText(
              addon.description,
              trimLines: 2,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Read more',
              trimExpandedText: 'Read less',
              style: AppTextStyle.bodySmallRegular.copyWith(
                color: AppColor.coolGrayText,
                height: 1.4,
              ),
              moreStyle: AppTextStyle.bodySmallRegular.copyWith(
                color: AppColor.blackColor,
                fontWeight: FontWeight.w600,
              ),
              lessStyle: AppTextStyle.bodySmallRegular.copyWith(
                color: AppColor.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          const SizedBox(height: 8),

          // Price
          Text(
            '\$${addon.price.toStringAsFixed(2)}',
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.blackShade1,
            ),
          ),

          const SizedBox(height: 10),

          // Add / Remove button — custom container so it looks identical
          // on Android and iOS (no platform-specific ink splash or text
          // casing from OutlinedButton).
          GestureDetector(
            key: ValueKey('toggle-addon-${addon.id}'),
            onTap: enabled ? () => onToggle(addon) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 36,
              decoration: BoxDecoration(
                color: selected ? AppColor.blackColor : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColor.blackColor
                      : AppColor.lightGreyColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    selected ? Icons.check : Icons.add,
                    size: 14,
                    color: selected ? Colors.white : AppColor.blackShade1,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    selected ? 'Remove' : 'Add',
                    style: AppTextStyle.bodySmallMedium.copyWith(
                      color: selected ? Colors.white : AppColor.blackShade1,
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

class BookingSelection {
  const BookingSelection({
    required this.service,
    this.variantId,
    this.addonIds = const {},
  });

  final ServiceItem service;
  final String? variantId;
  final Set<String> addonIds;
}
