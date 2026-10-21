import 'package:squadonsite/presentation/screens/book_service_screen/widgets/addon_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/app_network_image.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_country_code_picker.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_controller.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_detail_bottom_sheet.dart';

class BookServiceScreen extends GetView<BookServiceController> {
  const BookServiceScreen({super.key});

  @override
  Widget build(BuildContext context) => Obx(
    () => PopScope(
      canPop: !controller.isVerifyingPayment.value,
      child: Stack(
        children: [
          _buildContent(context),
          if (controller.isVerifyingPayment.value)
            const Positioned.fill(
              child: Material(
                color: Colors.white,
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.black),
                          SizedBox(height: 20),
                          Text(
                            'Confirming your booking…',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please wait while we verify your payment.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );

  Widget _buildContent(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Book Service',
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Service summary card ──────────────────────────────
                    _ServiceSummaryCard(controller: controller),
                    const SizedBox(height: 20),

                    // ── Service option (variants) ─────────────────────────
                    if (controller.service.hasVariants) ...[
                      _SectionTitle('Service Option'),
                      const SizedBox(height: 12),
                      _VariantSelector(controller: controller),
                      const SizedBox(height: 20),
                    ],

                    // ── Add-ons ───────────────────────────────────────────
                    if (controller.service.addons.any(
                      (a) => a.isActive && a.id.isNotEmpty,
                    )) ...[
                      _SectionTitle('Available Add-ons'),
                      const SizedBox(height: 12),
                      Obx(
                        () => AddonSelector(
                          addons: controller.service.addons,
                          selectedIds: controller.selectedAddonIds.toSet(),
                          enabled: !controller.isLoading.value,
                          onToggle: controller.toggleAddon,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Profile loading / error ───────────────────────────
                    Obx(
                      () => controller.isLoadingProfile.value
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: LinearProgressIndicator(),
                            )
                          : controller.profileError.value.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Text(controller.profileError.value),
                                  TextButton(
                                    onPressed: controller.loadProfile,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    // ── Booking period ────────────────────────────────────
                    _SectionTitle('Booking Period'),
                    const SizedBox(height: 10),
                    _BookingPeriodSelector(controller: controller),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Service date: ${MaterialLocalizations.of(context).formatMediumDate(controller.serviceDate.value)}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Service address ───────────────────────────────────
                    _SectionTitle('Service Address'),
                    const SizedBox(height: 10),
                    _AddressField(controller: controller),
                    TextButton.icon(
                      onPressed: controller.enterNewAddress,
                      icon: const Icon(Icons.add_location_alt_outlined),
                      label: const Text('Enter a new address'),
                    ),
                    const SizedBox(height: 20),

                    // ── Contact number ────────────────────────────────────
                    _SectionTitle('Contact Number'),
                    const SizedBox(height: 10),
                    _PhoneNumberField(
                      controller: controller,
                      phoneController: controller.phoneController,
                      hint: 'Enter your phone number',
                      validator: (value) =>
                          controller.bookingForSomeoneElse.value
                          ? null
                          : BookServiceController.validatePhone(value),
                    ),
                    Obx(
                      () => SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Booking for someone else',
                          style: AppTextStyle.bodyMediumRegular.copyWith(
                            color: AppColor.blackShade1,
                          ),
                        ),
                        activeColor: AppColor.blackColor,
                        value: controller.bookingForSomeoneElse.value,
                        onChanged: controller.isLoading.value
                            ? null
                            : (value) =>
                                  controller.bookingForSomeoneElse.value =
                                      value,
                      ),
                    ),
                    Obx(
                      () => !controller.bookingForSomeoneElse.value
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                _InputField(
                                  controller: controller.contactNameController,
                                  hint: 'Person\'s full name',
                                  icon: Icons.person_outline,
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty
                                      ? 'Enter the person\'s name'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                _PhoneNumberField(
                                  controller: controller,
                                  phoneController:
                                      controller.alternatePhoneController,
                                  hint: 'Person\'s contact number',
                                  validator:
                                      BookServiceController.validatePhone,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                    ),

                    // ── Special instructions ──────────────────────────────
                    _SectionTitle('Special Instructions'),
                    const SizedBox(height: 4),
                    Text(
                      'Optional — share anything the pro should know',
                      style: AppTextStyle.bodySmallRegular.copyWith(
                        color: AppColor.coolGrayText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _FocusBorderField(
                      controller: controller.instructionsController,
                      hint: 'e.g. Ring the doorbell on arrival',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),

                    // ── Payment breakdown ─────────────────────────────────
                    _SectionTitle('Payment Breakdown'),
                    const SizedBox(height: 10),
                    _PaymentBreakout(controller: controller),
                    const SizedBox(height: 20),

                    // ── Cancellation policy ───────────────────────────────
                    _CancellationPolicy(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          _BottomBar(controller: controller),
        ],
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.titleMediumSemiBold.copyWith(
        color: AppColor.blackShade1,
      ),
    );
  }
}

// ── Service summary card ──────────────────────────────────────────────────────

class _ServiceSummaryCard extends StatelessWidget {
  final BookServiceController controller;
  const _ServiceSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final imageUrl = controller.service.featuredImage.isNotEmpty
        ? '${ApiEndpoints.imageUrl}${controller.service.featuredImage}'
        : '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: imageUrl,
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.service.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${controller.service.ratingsAverage.toStringAsFixed(1)} (${controller.service.ratingsQuantity} reviews)',
                        style: AppTextStyle.bodySmallRegular.copyWith(
                          color: AppColor.coolGrayText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Obx(
                  () => Text(
                    '\$${controller.serviceFee.toStringAsFixed(2)}',
                    style: AppTextStyle.titleSmallSemiBold.copyWith(
                      color: AppColor.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                // const SizedBox(height: 4),
                // TextButton.icon(
                //   onPressed: () =>
                //       ServiceDetailBottomSheet.show(controller.service),
                //   style: TextButton.styleFrom(
                //     padding: EdgeInsets.zero,
                //     minimumSize: const Size(0, 36),
                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     foregroundColor: AppColor.blackColor,
                //   ),
                //   icon: const Icon(Icons.info_outline_rounded, size: 18),
                //   label: const Text('View service details'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Variant selector — same card style as the bottom sheet ───────────────────

class _VariantSelector extends StatelessWidget {
  final BookServiceController controller;
  const _VariantSelector({required this.controller});

  String _formatDuration(int minutes) {
    if (minutes <= 0) return '';
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final variants = controller.activeVariants;
    return Obx(
      () => Column(
        children: List.generate(variants.length, (i) {
          final v = variants[i];
          final selected = controller.selectedVariant.value?.id == v.id;
          final hasDiscount = v.discountPercentage > 0;

          return GestureDetector(
            onTap: controller.isLoading.value
                ? null
                : () => controller.selectedVariant.value = v,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: selected ? AppColor.blackColor : Colors.white,
                border: Border.all(
                  color: selected
                      ? AppColor.blackColor
                      : AppColor.lightGreyColor,
                  width: selected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Radio dot
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
                  // Name + duration
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.name,
                          style: AppTextStyle.titleSmallSemiBold.copyWith(
                            color: selected
                                ? Colors.white
                                : AppColor.blackShade1,
                          ),
                        ),
                        if (v.duration > 0) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                size: 11,
                                color: AppColor.coolGrayText,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                _formatDuration(v.duration),
                                style: AppTextStyle.labelSmallRegular.copyWith(
                                  color: selected
                                      ? Colors.white60
                                      : AppColor.coolGrayText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Price block
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${v.offerPrice}',
                        style: AppTextStyle.titleSmallSemiBold.copyWith(
                          color: selected ? Colors.white : AppColor.blackColor,
                          fontSize: 15,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(height: 2),
                        Text(
                          '\$${v.actualPrice}',
                          style: AppTextStyle.labelSmallRegular.copyWith(
                            color: selected
                                ? Colors.white60
                                : AppColor.coolGrayText,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
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
                            '${v.discountPercentage.toInt()}% off',
                            style: AppTextStyle.labelSmallMedium.copyWith(
                              color: selected
                                  ? Colors.white
                                  : AppColor.green2Color,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Booking period selector ───────────────────────────────────────────────────

class _BookingPeriodSelector extends StatelessWidget {
  final BookServiceController controller;
  const _BookingPeriodSelector({required this.controller});

  static const _labels = {
    'today': 'Today',
    'tomorrow': 'Tomorrow',
    'week': 'This Week',
    'month': 'This Month',
  };

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: BookServiceController.periods.map((period) {
          final selected = controller.selectedPeriod.value == period;
          return GestureDetector(
            onTap: controller.isLoading.value
                ? null
                : () => controller.selectPeriod(context, period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColor.blackColor : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? AppColor.blackColor
                      : AppColor.lightGreyColor,
                ),
              ),
              child: Text(
                _labels[period] ?? period,
                style: AppTextStyle.bodySmallMedium.copyWith(
                  color: selected ? Colors.white : AppColor.blackShade1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Address field with inline Change button ───────────────────────────────────

class _AddressField extends StatelessWidget {
  final BookServiceController controller;
  const _AddressField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        children: [
          // Address display row
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: controller.changeAddress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppColor.coolGrayText,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() {
                      // Access selectedAddress so Obx re-renders when it
                      // changes; the actual text comes from addressController.
                      controller.selectedAddress.value;
                      final text = controller.addressController.text;
                      return Text(
                        text.isNotEmpty ? text : 'No address selected',
                        style: AppTextStyle.bodyMediumRegular.copyWith(
                          color: text.isNotEmpty
                              ? AppColor.blackShade1
                              : AppColor.coolGrayText,
                          height: 1.4,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          // Divider + Change button
          const Divider(height: 1, color: AppColor.lightGreyColor),
          InkWell(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            onTap: controller.changeAddress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_location_alt_outlined,
                    size: 16,
                    color: AppColor.blackColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Change service address',
                    style: AppTextStyle.bodySmallMedium.copyWith(
                      color: AppColor.blackColor,
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

// ── Generic input field (focus border) ───────────────────────────────────────

class _PhoneNumberField extends StatelessWidget {
  final BookServiceController controller;
  final TextEditingController phoneController;
  final String hint;
  final String? Function(String?)? validator;

  const _PhoneNumberField({
    required this.controller,
    required this.phoneController,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => Obx(
    () => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonCountryCodePicker(
          onChanged: controller.onCountryChanged,
          initialSelection: controller.selectedCountry.value.code ?? 'US',
          favorite: const ['+1', 'US'],
          height: 52,
          borderRadius: 12,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InputField(
            controller: phoneController,
            hint: hint,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: validator,
          ),
        ),
      ],
    ),
  );
}

class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.validator,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focused ? AppColor.blackColor : AppColor.lightGreyColor,
          width: _focused ? 1.5 : 1,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        validator: widget.validator,
        textInputAction: widget.maxLines > 1
            ? TextInputAction.newline
            : TextInputAction.next,
        maxLines: widget.maxLines,
        keyboardType: widget.maxLines > 1
            ? TextInputType.multiline
            : widget.keyboardType,
        style: AppTextStyle.bodyMediumRegular.copyWith(
          color: AppColor.blackShade1,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyle.bodyMediumRegular.copyWith(
            color: AppColor.coolGrayText,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: _focused ? AppColor.blackColor : AppColor.coolGrayText,
            size: 20,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

// ── Special instructions — focus-border multiline field ──────────────────────

class _FocusBorderField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _FocusBorderField({
    required this.controller,
    required this.hint,
    this.maxLines = 4,
  });

  @override
  State<_FocusBorderField> createState() => _FocusBorderFieldState();
}

class _FocusBorderFieldState extends State<_FocusBorderField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focused ? AppColor.blackColor : AppColor.lightGreyColor,
          width: _focused ? 1.5 : 1,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: AppTextStyle.bodyMediumRegular.copyWith(
          color: AppColor.blackShade1,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyle.bodyMediumRegular.copyWith(
            color: AppColor.coolGrayText,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 14, left: 12, right: 8),
            child: Icon(
              Icons.notes_outlined,
              color: _focused ? AppColor.blackColor : AppColor.coolGrayText,
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
        ),
      ),
    );
  }
}

// ── Payment breakdown ─────────────────────────────────────────────────────────

class _PaymentBreakout extends StatelessWidget {
  final BookServiceController controller;
  const _PaymentBreakout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Obx(
        () => Column(
          children: [
            // Service base fee
            _BreakdownRow(
              label: controller.service.name,
              value: '\$${controller.serviceFee.toStringAsFixed(2)}',
            ),

            // Each selected addon on its own row
            for (final addon in controller.selectedAddons) ...[
              const SizedBox(height: 10),
              _BreakdownRow(
                label: addon.name,
                value: '\$${addon.price.toStringAsFixed(2)}',
                isAddon: true,
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(height: 1, color: AppColor.lightGreyColor),
            ),

            // Estimated total
            _BreakdownRow(
              label: 'Total',
              value: '\$${controller.total.toStringAsFixed(2)}',
              isBold: true,
            ),

            const SizedBox(height: 10),

            // Disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.neutral1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Includes your service and selected add-ons. Charged in USD.',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodySmallRegular.copyWith(
                  color: AppColor.coolGrayText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isAddon;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isAddon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Addon indicator dot
        if (isAddon)
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.coolGrayText,
              ),
            ),
          ),
        Expanded(
          child: Text(
            label,
            style: isBold
                ? AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                  )
                : AppTextStyle.bodyMediumRegular.copyWith(
                    color: AppColor.blackShade1,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: isBold
              ? AppTextStyle.titleSmallSemiBold.copyWith(
                  color: AppColor.blackColor,
                  fontSize: 15,
                )
              : AppTextStyle.bodyMediumRegular.copyWith(
                  color: AppColor.blackShade1,
                ),
        ),
      ],
    );
  }
}

// ── Cancellation policy ───────────────────────────────────────────────────────

class _CancellationPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CANCELLATION POLICY',
          style: AppTextStyle.labelMediumSemiBold.copyWith(
            color: AppColor.coolGrayText,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Help us reduce the time of a technician by avoiding service cancellation. A 100% cancellation charge will be applied if the technician is assigned.',
          style: AppTextStyle.bodySmallRegular.copyWith(
            color: AppColor.coolGrayText,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Bottom bar — shows total + confirm button ─────────────────────────────────

class _BottomBar extends StatelessWidget {
  final BookServiceController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColor.lightGreyColor)),
      ),
      child: Obx(
        () => Row(
          children: [
            // Estimated total
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${controller.total.toStringAsFixed(2)}',
                    style: AppTextStyle.headlineSmallSemiBold.copyWith(
                      color: AppColor.blackColor,
                    ),
                  ),
                  Text(
                    'Total (USD)',
                    style: AppTextStyle.bodySmallRegular.copyWith(
                      color: AppColor.coolGrayText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Confirm & Book button
            Expanded(
              flex: 2,
              child: CommonButton(
                label: controller.isLoading.value
                    ? 'Processing...'
                    : 'Confirm & Book',
                onTap:
                    controller.isLoading.value ||
                        controller.isLoadingProfile.value ||
                        controller.profileError.value.isNotEmpty
                    ? null
                    : controller.confirmAndBook,
                backgroundColor: AppColor.blackColor,
                foregroundColor: Colors.white,
                height: 52,
                borderRadius: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
