import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'address_form_controller.dart';

class AddressFormScreen extends GetView<AddressFormController> {
  const AddressFormScreen({super.key});

  static const background = Color(0xFFF1F0F5);

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF707074), fontSize: 15),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFDCDCDD)),
    ),
    counterText: '',
  );

  Widget _field(
    TextEditingController text,
    String hint, {
    bool required = false,
    int limit = 200,
  }) => CommonTextFormField(
    controller: text,
    hintText: hint,
    maxLength: limit,
    textCapitalization: TextCapitalization.words,
    textInputAction: TextInputAction.next,
    borderRadius: 14,
    borderColor: const Color(0xFFDCDCDD),
    focusedBorderColor: Colors.black,
    contentHorizontalPadding: 16,
    contentVerticalPadding: 18,
    hintStyle: const TextStyle(color: Color(0xFF707074), fontSize: 15),
    validator: required
        ? CommonValidators.required(
            message: 'Please enter ${hint.replaceAll(' *', '').toLowerCase()}',
          )
        : null,
  );

  @override
  Widget build(BuildContext context) => Obx(
    () => PopScope(
      canPop: !controller.isSaving.value,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          surfaceTintColor: background,
          leading: BackButton(
            color: Colors.black,
            onPressed: controller.isSaving.value ? null : () => Get.back(),
          ),
          title: const Text(
            'Location Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  AbsorbPointer(
                    absorbing: controller.isSaving.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: AddressLabel.values.map((label) {
                                  final selected =
                                      controller.selectedLabel.value == label;
                                  return Expanded(
                                    child: Semantics(
                                      selected: selected,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(32),
                                        onTap: () =>
                                            controller.selectLabel(label),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? const Color(0xFF050709)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  switch (label) {
                                                    AddressLabel.home =>
                                                      Icons.home_rounded,
                                                    AddressLabel.office =>
                                                      Icons.business_outlined,
                                                    AddressLabel.work =>
                                                      Icons
                                                          .work_outline_rounded,
                                                    AddressLabel.other =>
                                                      Icons.near_me_outlined,
                                                  },
                                                  size: 20,
                                                  color: selected
                                                      ? Colors.white
                                                      : const Color(0xFF24262B),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  label.displayName,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: selected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF24262B,
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 22),
                            _field(
                              controller.houseController,
                              'Building / Flat / Floor (optional)',
                              limit: 200,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              controller.buildingController,
                              'Street (optional)',
                              limit: 200,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'Building and floor details are saved separately and won’t move the map pin.',
                                  style: TextStyle(
                                    color: Color(0xFF707074),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InputDecorator(
                                    decoration: _decoration('').copyWith(
                                      labelText: 'Area',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 52,
                                      ),
                                      child: Text(
                                        controller.area.value.isEmpty
                                            ? 'Search on the map or enter the address below'
                                            : controller.area.value,
                                        style: const TextStyle(
                                          color: Color(0xFF99999D),
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _MapChange(controller: controller),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _field(
                              controller.addressLineController,
                              'Address line *',
                              required: true,
                              limit: 500,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              controller.cityController,
                              'City',
                              limit: 100,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              controller.stateController,
                              'State',
                              limit: 100,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              controller.zipcodeController,
                              'ZIP / Postal code',
                              limit: 30,
                            ),
                            if (controller.checkoutMode)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Save this address to my profile',
                                ),
                                value: controller.saveToProfile.value,
                                onChanged: (value) =>
                                    controller.saveToProfile.value =
                                        value ?? false,
                              ),
                            if (!controller.checkoutMode ||
                                controller.saveToProfile.value)
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  controller.isOriginallyDefault
                                      ? 'Default address'
                                      : 'Set as default address',
                                ),
                                value: controller.isDefault.value,
                                onChanged: controller.isOriginallyDefault
                                    ? null
                                    : (value) =>
                                          controller.isDefault.value = value,
                              ),
                            if (controller.saveError.value.isNotEmpty)
                              Text(
                                controller.saveError.value,
                                style: const TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CommonButton(
                    label: controller.checkoutMode
                        ? 'Use this address'
                        : controller.isEditMode
                        ? 'Update Address'
                        : 'Save Address',
                    onTap: controller.isSaving.value
                        ? null
                        : controller.saveAddress,
                    isLoading: controller.isSaving.value,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _MapChange extends StatelessWidget {
  const _MapChange({required this.controller});

  final AddressFormController controller;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Change map location',
      child: InkWell(
        onTap: controller.changeLocation,
        borderRadius: BorderRadius.circular(14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 78,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const ColoredBox(
                  color: AddressFormScreen.background,
                  child: SizedBox.expand(),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 35, color: Colors.black),
                    Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
