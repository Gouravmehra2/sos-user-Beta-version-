import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/location_detail_screen/location_detail_controller.dart';

class LocationDetailScreen extends StatelessWidget {
  const LocationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationDetailController>(
      builder: (controller) {
        return MyScaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColor.backgroundGradient,
            ),
            child: Column(
              children: [
                SizedBox(height: Get.height*0.06),
                Row(
                  children: [
                    InkWell(
                      onTap: (){Get.back();},
                      child: Container(
                        margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.darkGray.withValues(alpha: 0.05),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                    Align(alignment: Alignment.center,child: _buildTitle()),
                  ],
                ),
                Expanded(
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchBar(controller),
                          const SizedBox(height: 14),
                          _buildCurrentLocationButton(controller),
                          const SizedBox(height: 28),
                          _buildEnterDetailsSection(controller),
                          const SizedBox(height: 22),
                          _buildSaveAsSection(controller),
                          const SizedBox(height: 28),
                          _buildConfirmButton(controller),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Title ──────────────────────────────────────────────────────────────────

  Widget _buildTitle() {
    return Text(
      'Enter Your Location',
      style: AppTextStyle.headlineMediumSemiBold.copyWith(
        color: AppColor.blackShade1,
        fontSize: 20
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar(LocationDetailController controller) {
    return CommonTextFormField(readOnly: true,
      onTap: (){
        Get.toNamed(AppRoutes.mapScreen);
      },
      controller: controller.searchController,
      hintText: 'Search for area, street, or landmark',
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.search,
      prefixIcon: Icons.search_rounded,
      onChanged: controller.onSearchChanged,
      borderColor: Colors.transparent,
      backgroundColor: Colors.white,
    );
  }

  // ── Use current location ───────────────────────────────────────────────────

  Widget _buildCurrentLocationButton(LocationDetailController controller) {
    return GestureDetector(
      onTap: controller.useCurrentLocation,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.my_location_rounded,
            size: 20,
            color: AppColor.brownAccentPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            'Use Current Location',
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.brownAccentPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Enter Details section ──────────────────────────────────────────────────

  Widget _buildEnterDetailsSection(LocationDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Details',
          style: AppTextStyle.titleLargeBold.copyWith(
            color: AppColor.blackShade1,
          ),
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('House / Flat / Block No.'),
        const SizedBox(height: 6),
        CommonTextFormField(
          controller: controller.houseController,
          hintText: '',
          textInputAction: TextInputAction.next,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
          validator: CommonValidators.required(
            message: 'House / Flat / Block No. is required',
          ),
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Apartment / Road / Area'),
        const SizedBox(height: 6),
        CommonTextFormField(
          controller: controller.apartmentController,
          hintText: '',
          textInputAction: TextInputAction.next,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
          validator: CommonValidators.required(
            message: 'Apartment / Road / Area is required',
          ),
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Landmark (Optional)'),
        const SizedBox(height: 6),
        CommonTextFormField(
          controller: controller.landmarkController,
          hintText: '',
          textInputAction: TextInputAction.done,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
        ),
      ],
    );
  }

  // ── Save as section ────────────────────────────────────────────────────────

  Widget _buildSaveAsSection(LocationDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Save as'),
        const SizedBox(height: 10),
        Obx(() => _SaveAsRow(
              selected: controller.selectedSaveAs.value,
              onSelect: controller.selectSaveAs,
            )),
      ],
    );
  }

  // ── Confirm button ─────────────────────────────────────────────────────────

  Widget _buildConfirmButton(LocationDetailController controller) {
    return CommonButton(
      label: 'Confirm Location',
      onTap: controller.confirmLocation,
      backgroundColor: AppColor.blackColor,
      foregroundColor: Colors.white,
    );
  }

  // ── Shared field label ─────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextStyle.bodyMediumRegular.copyWith(
        color: AppColor.grey2Color,
      ),
    );
  }
}

// ─── Save-as chip row ─────────────────────────────────────────────────────────

class _SaveAsRow extends StatelessWidget {
  final SaveAsType selected;
  final ValueChanged<SaveAsType> onSelect;

  const _SaveAsRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SaveAsChip(
          label: 'Home',
          icon: Icons.home_outlined,
          type: SaveAsType.home,
          selected: selected,
          onSelect: onSelect,
        ),
        const SizedBox(width: 10),
        _SaveAsChip(
          label: 'Office',
          icon: Icons.work_outline_rounded,
          type: SaveAsType.office,
          selected: selected,
          onSelect: onSelect,
        ),
        const SizedBox(width: 10),
        _SaveAsChip(
          label: 'Other',
          icon: Icons.location_on_outlined,
          type: SaveAsType.other,
          selected: selected,
          onSelect: onSelect,
        ),
      ],
    );
  }
}

class _SaveAsChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final SaveAsType type;
  final SaveAsType selected;
  final ValueChanged<SaveAsType> onSelect;

  const _SaveAsChip({
    required this.label,
    required this.icon,
    required this.type,
    required this.selected,
    required this.onSelect,
  });

  bool get _isSelected => type == selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isSelected ? AppColor.blackColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _isSelected ? AppColor.blackColor : AppColor.lightGreyColor,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: _isSelected ? Colors.white : AppColor.blackShade1,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyle.bodyMediumMedium.copyWith(
                color: _isSelected ? Colors.white : AppColor.blackShade1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
