import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_country_code_picker.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/personal_information_screen/personal_information_controller.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PersonalInformationController>();
    return MyScaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Edit Profile".tr,
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileAvatar(controller: controller),
                    const SizedBox(height: 24),
                    _SectionCard(
                      children: [
                        CommonTextFormField(
                          label: "Full Name".tr,
                          hintText: "Full Name".tr,
                          prefixIcon: Icons.person_outline,
                          controller: controller.nameController,
                          borderRadius: 10,
                          validator: controller.validateRequired,
                        ),
                        const SizedBox(height: 16),
                        CommonTextFormField(
                          label: "login_hint_phone".tr,
                          hintText: "login_hint_phone".tr,
                          prefixIcon: Icons.phone_outlined,
                          controller: controller.phoneController,
                          readOnly: true,
                          backgroundColor: AppColor.lightGreyColor,
                          borderRadius: 10,
                          validator: controller.validatePhone,
                        ),
                        const SizedBox(height: 16),
                        CommonTextFormField.email(
                          label: "Email Address".tr,
                          hintText: "Email Address".tr,
                          controller: controller.emailController,
                          backgroundColor: AppColor.lightGreyColor,
                          borderRadius: 10,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel(label: "Gender".tr),
                        const SizedBox(height: 6),
                        Obx(
                          () => _DropdownField(
                            value: controller.gender.value.isEmpty
                                ? null
                                : controller.gender.value,
                            items: const ['Male', 'Female', 'Other'],
                            onChanged: (value) {
                              controller.gender.value = value ?? '';
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel(label: "Date of Birth".tr),
                        const SizedBox(height: 6),
                        Obx(
                          () => CommonTextFormField(
                            hintText: controller.dob.value.isEmpty
                                ? "Select date of birth".tr
                                : controller.dob.value,
                            prefixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: () => controller.pickDate(context),
                            borderRadius: 10,
                            suffixIcon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                              color: AppColor.coolGrayText,
                            ),
                            validator: (_) => controller.dob.value.isEmpty
                                ? 'This field is required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          color: AppColor.blackColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Additional Contact".tr,
                          style: AppTextStyle.headlineSmallSemiBold.copyWith(
                            color: AppColor.blackShade1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _SectionCard(
                      children: [
                        Text(
                          "Alternative Phone".tr,
                          style: AppTextStyle.bodyMediumRegular.copyWith(
                            color: AppColor.coolGrayText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CommonCountryCodePicker(
                              onChanged: controller.onCountryChanged,
                              initialSelection: 'US',
                              height: 52,
                              borderRadius: 12,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CommonTextFormField(
                                hintText: "10-digit phone number".tr,
                                keyboardType: TextInputType.phone,
                                controller: controller.altPhoneController,
                                borderRadius: 12,
                                backgroundColor: AppColor.lightGreyColor,
                                borderColor: Colors.transparent,
                                validator: controller.validatePhone,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CommonButton(
                      label: controller.isSaving.value
                          ? "Saving...".tr
                          : "Save Profile".tr,
                      onTap: controller.saveProfile,
                      backgroundColor: AppColor.blackColor,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (controller.isLoading.value || controller.isUploadingImage.value)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final PersonalInformationController controller;

  const _ProfileAvatar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(
            () => InkWell(
              onTap: controller.pickProfileImage,
              child: Stack(
                children: [
                  CircleAvatar(radius: 54, backgroundImage: _imageProvider()),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.lightGreyColor),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: controller.pickProfileImage,
            child: Text(
              (controller.isUploadingImage.value
                      ? "Uploading...".tr
                      : "Change Picture".tr)
                  .tr,
              style: AppTextStyle.titleSmallSemiBold.copyWith(
                color: AppColor.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _imageProvider() {
    final local = controller.profileImage.value;
    if (local != null) return FileImage(local);
    final url = controller.profileImageUrl.value;
    final uri = Uri.tryParse(url);
    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty) {
      return NetworkImage(url);
    }
    return const AssetImage('assets/images/person_image.png');
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.blackColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    (label).tr,
    style: AppTextStyle.titleSmallSemiBold.copyWith(
      color: AppColor.blackShade1,
    ),
  );
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.lightGreyColor, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            size: 20,
            color: AppColor.coolGrayText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  "Select gender".tr,
                  style: AppTextStyle.titleSmallMedium.copyWith(
                    color: AppColor.coolGrayText,
                  ),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.coolGrayText,
                ),
                style: AppTextStyle.titleSmallMedium.copyWith(
                  color: AppColor.blackShade1,
                ),
                items: items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text((item).tr)),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
