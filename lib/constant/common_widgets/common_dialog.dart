import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';

class CommonDialog {
  static Future<T?> show<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<T>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: child,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a bottom-sheet style dialog for picking image from gallery or camera.
  /// Returns the picked [XFile] or null if cancelled.
  static Future<XFile?> showImagePickerDialog() async {
    XFile? result;
    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColor.lightGreyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text('Upload Profile Photo',
                  style: AppTextStyle.titleLargeSemiBold
                      .copyWith(color: AppColor.blackShade1)),
              const SizedBox(height: 4),
              Text('Choose from below options',
                  style: AppTextStyle.bodySmallRegular
                      .copyWith(color: AppColor.coolGrayText)),
              const SizedBox(height: 20),
              _PickerOption(
                icon: Icons.photo_library_outlined,
                label: 'Choose from Gallery',
                onTap: () async {
                  Get.back();
                  result = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 80);
                },
              ),
              const SizedBox(height: 12),
              _PickerOption(
                icon: Icons.camera_alt_outlined,
                label: 'Take a Photo',
                onTap: () async {
                  Get.back();
                  result = await ImagePicker()
                      .pickImage(source: ImageSource.camera, imageQuality: 80);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    return result;
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.lightGreyColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.lightGreyColor),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColor.brownAccentPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColor.brownAccentPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Text(label,
                style: AppTextStyle.titleSmallSemiBold
                    .copyWith(color: AppColor.blackShade1)),
          ],
        ),
      ),
    );
  }
}
