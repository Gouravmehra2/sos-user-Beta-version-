import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/custom_search_bar.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_controller.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  static const double _hPad = 16.0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectLocationController>(
      builder: (controller) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: MyScaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: SafeArea(
              child: Column(
                children: [
                  // ── AppBar ───────────────────────────────────────────
                  _AppBar(),
                  // ── Scrollable content ───────────────────────────────
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColor.blackColor,
                      onRefresh: controller.fetchAddresses,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: _hPad,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Search Bar ───────────────────────────
                            CustomSearchBar(
                              controller: controller.searchController,
                              hintText: 'select_location_search_hint'.tr,
                              onSearch: controller.onSearchChanged,
                            ),
                            const SizedBox(height: 20),

                            // ── Quick Actions ────────────────────────
                            _QuickActionsRow(controller: controller),
                            const SizedBox(height: 24),

                            // ── Saved Addresses header ───────────────
                            Text(
                              'select_location_saved_addresses'.tr,
                              style: AppTextStyle.labelMediumSemiBold.copyWith(
                                color: AppColor.darkGray,
                                letterSpacing: 1.2,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // ── Addresses body (state-driven) ────────
                            _AddressesBody(controller: controller),
                            const SizedBox(height: 4),

                            // ── View All ─────────────────────────────
                            Obx(
                              () => controller.canViewAll
                                  ? _ViewAllButton(onTap: controller.onViewAll)
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Bottom Buttons (pinned) ──────────────────────────
                  // _BottomButtons(controller: controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.darkGray.withValues(alpha: 0.05),
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            'select_location_title'.tr,
            style: AppTextStyle.titleLargeBold.copyWith(
              color: AppColor.blackShade1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions Row ────────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  final SelectLocationController controller;
  const _QuickActionsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _QuickActionTile(
              icon: AppAssets.currentLocationImage,
              label: 'select_location_use_current'.tr,
              onTap: controller.isLoadingLocation.value
                  ? null
                  : controller.onUseCurrentLocation,
              isLoading: controller.isLoadingLocation.value,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionTile(
            icon: AppAssets.addLocationImage,
            label: 'select_location_add_new'.tr,
            onTap: controller.onAddNewAddress,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionTile(
            icon: AppAssets.whatsUpImage,
            label: 'select_location_request_friend'.tr,
            onTap: controller.onRequestFromFriend,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.borderColor.withValues(alpha: 0.30),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowGrey.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  )
                : Image.asset(icon, height: 30, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodySmallMedium.copyWith(
                color: AppColor.blackShade1,
                height: 1.4,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Address body (handles all three states) ─────────────────────────────────

class _AddressesBody extends StatelessWidget {
  final SelectLocationController controller;
  const _AddressesBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.screenState.value) {
        case LocationScreenState.loading:
          return const _AddressesShimmer();

        case LocationScreenState.error:
          return _ErrorCard(
            message: controller.errorMessage.value,
            onRetry: controller.fetchAddresses,
          );

        case LocationScreenState.success:
          if (controller.addresses.isEmpty) {
            return _EmptyAddresses(onAdd: controller.onAddNewAddress);
          }
          return _SavedAddressList(controller: controller);
      }
    });
  }
}

// ─── Loading shimmer ──────────────────────────────────────────────────────────

class _AddressesShimmer extends StatelessWidget {
  const _AddressesShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderColor.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowGrey.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(3, (i) {
          final isLast = i == 2;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    _ShimmerBox(width: 64, height: 64, radius: 12),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(width: 80, height: 12, radius: 6),
                          const SizedBox(height: 8),
                          _ShimmerBox(
                            width: double.infinity,
                            height: 10,
                            radius: 6,
                          ),
                          const SizedBox(height: 4),
                          _ShimmerBox(width: 140, height: 10, radius: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: AppColor.lightGreyColor,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColor.lightGreyColor.withValues(alpha: _anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// ─── Error card ───────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderColor.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowGrey.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 44,
            color: AppColor.coolGrayText,
          ),
          const SizedBox(height: 12),
          Text(
            'select_location_error_load'.tr,
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.blackShade1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: AppTextStyle.bodySmallRegular.copyWith(
              color: AppColor.coolGrayText,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColor.blackColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'select_location_retry'.tr,
                style: AppTextStyle.buttonSmall.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyAddresses extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyAddresses({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.borderColor.withValues(alpha: 0.30),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowGrey.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 44,
              color: AppColor.coolGrayText,
            ),
            const SizedBox(height: 12),
            Text(
              'select_location_empty_title'.tr,
              style: AppTextStyle.titleSmallSemiBold.copyWith(
                color: AppColor.blackShade1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'select_location_empty_subtitle'.tr,
              style: AppTextStyle.bodySmallRegular.copyWith(
                color: AppColor.coolGrayText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Saved Addresses List ─────────────────────────────────────────────────────

class _SavedAddressList extends StatelessWidget {
  final SelectLocationController controller;
  const _SavedAddressList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.borderColor.withValues(alpha: 0.30),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowGrey.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: List.generate(controller.visibleAddressCount, (index) {
            final address = controller.addresses[index];
            final isLast = index == controller.visibleAddressCount - 1;
            return Column(
              children: [
                Obx(
                  () => _AddressTile(
                    address: address,
                    isSelected: controller.selectedIndex.value == index,
                    isSaving:
                        controller.savingIndex.value == index ||
                        controller.deletingAddressId.value == address.id,
                    iconPath: controller.iconFor(address),
                    iconColor: controller.iconColorFor(address),
                    onTap: () => controller.selectAddress(index),
                    onEdit: () => controller.onEditAddress(index),
                    onDelete: () => controller.onDeleteAddress(index),
                    onShare: () => controller.onShareAddress(index),
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColor.lightGreyColor,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ─── Address Tile ─────────────────────────────────────────────────────────────

class _AddressTile extends StatelessWidget {
  final UserAddress address;
  final bool isSelected;
  final bool isSaving;
  final String iconPath;
  final Color iconColor;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.isSaving,
    required this.iconPath,
    required this.iconColor,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.lightGreen1Color.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.borderColor.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        height: 24,
                        color: iconColor,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        address.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.labelMediumSemiBold.copyWith(
                          color: AppColor.blackShade2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Address title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            address.label,
                            style: AppTextStyle.titleSmallSemiBold.copyWith(
                              color: AppColor.blackShade1,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isSaving)
                            const SizedBox(
                              width: 13,
                              height: 13,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppColor.blackColor,
                              ),
                            )
                          else if (isSelected)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.lightGreen1Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'select_location_selected_badge'.tr,
                                style: AppTextStyle.labelSmallMedium.copyWith(
                                  color: AppColor.green2Color,
                                  fontSize: 9,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        address.displayAddress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodySmallRegular.copyWith(
                          color: AppColor.grey2Color,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Share, Edit and Delete buttons at the bottom
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    imagePath: AppAssets.shareIcon,
                    label: 'Share',
                    color: AppColor.primaryGrey,
                    onTap: onShare,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    imagePath: AppAssets.editIcon,
                    label: 'Edit',
                    color: const Color(0xFF333333),
                    onTap: onEdit,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    imagePath: AppAssets.deleteIcon,
                    label: 'Delete',
                    color: Colors.red,
                    onTap: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String imagePath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor.borderColor.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 16,
                width: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodySmallMedium.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _ActionIcon extends StatelessWidget {
  final String imagePath;
  final Color? color;
  final VoidCallback onTap;

  const _ActionIcon({required this.imagePath, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, height: 20, width: 17, color: color),
    );
  }
}

// ─── View All Button ──────────────────────────────────────────────────────────

class _ViewAllButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewAllButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColor.blackColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowGrey.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          'select_location_view_all'.tr,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            color: AppColor.blackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}


