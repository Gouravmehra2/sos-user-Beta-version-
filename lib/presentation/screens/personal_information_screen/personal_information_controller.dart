import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_dialog.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/model/auth_model.dart';

class PersonalInformationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final altPhoneController = TextEditingController();

  final gender = ''.obs;
  final dob = ''.obs;
  final profileImage = Rx<File?>(null);
  final profileImageUrl = ''.obs;
  final isLoading = true.obs;
  final isSaving = false.obs;
  final isUploadingImage = false.obs;

  String countryCode = '+1';

  @override
  void onInit() {
    super.onInit();
    _applyUser(Get.find<AuthSession>().user);
    loadProfile();
  }

  Future<void> loadProfile() async {
    final session = Get.find<AuthSession>();
    if (!session.hasToken) {
      isLoading.value = false;
      return;
    }
    try {
      final response = await Get.find<ApiRepo>().me();
      if (!response.success || response.user == null) {
        throw Exception('Invalid profile response');
      }
      _applyUser(response.user);
      await session.update(response);
    } catch (_) {
      _showApiError("Unable to load your profile. Please try again.".tr);
    } finally {
      isLoading.value = false;
    }
  }

  void _applyUser(AuthUser? user) {
    if (user == null) return;
    nameController.text = user.name;
    phoneController.text = user.phone;
    emailController.text = user.email;
    altPhoneController.text = user.alternateContact;
    gender.value = _displayGender(user.gender);
    dob.value = _displayDate(user.dateOfBirth);
    profileImageUrl.value = user.profileImageUrl.trim();
  }

  Future<void> pickProfileImage() async {
    if (isSaving.value) return;
    final file = await CommonDialog.showImagePickerDialog();
    if (file == null) return;
    profileImage.value = File(file.path);
    await uploadProfileImage(file);
  }

  Future<void> uploadProfileImage(XFile file) async {
    try {
      isUploadingImage.value = true;
      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      });
      await Get.find<DioClient>().post(
        ApiEndpoints.uploadProfileImage,
        data: formData,
      );
      await loadProfile();
    } catch (error) {
      profileImage.value = null;
      _showApiError(
        _apiErrorMessage(error, "Unable to upload profile image.".tr),
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  void onCountryChanged(CountryCode code) {
    countryCode = code.dialCode ?? '+1';
  }

  Future<void> pickDate(BuildContext context) async {
    final parsed = _parseDate(dob.value) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: parsed.isAfter(DateTime.now()) ? DateTime.now() : parsed,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColor.blackColor,
            onPrimary: Colors.white,
            onSurface: AppColor.blackShade1,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) dob.value = _formatDate(picked);
  }

  Future<void> saveProfile() async {
    if (isSaving.value || isUploadingImage.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (gender.value.isEmpty) {
      _showApiError("Please select your gender.".tr);
      return;
    }
    if (dob.value.isEmpty) {
      _showApiError("Please select your date of birth.".tr);
      return;
    }

    try {
      isSaving.value = true;
      final response = await Get.find<DioClient>().put(
        ApiEndpoints.updateMe,
        data: {
          'name': nameController.text.trim(),
          'phone': _digits(phoneController.text),
          'dateOfBirth': _apiDate(dob.value),
          'gender': gender.value.toLowerCase(),
          'alternateContact': _digits(altPhoneController.text),
        },
      );
      final body = response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      if (body['success'] == false) {
        throw Exception(
          body['message']?.toString() ?? 'Profile update failed.',
        );
      }
      await loadProfile();
      AppSnackbar.show("Success".tr, "Profile updated successfully.".tr);
    } catch (error) {
      _showApiError(
        _apiErrorMessage(error, "Unable to update your profile.".tr),
      );
    } finally {
      isSaving.value = false;
    }
  }

  String? validateRequired(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? validatePhone(String? value) {
    final required = validateRequired(value);
    if (required != null) return required;
    return _digits(value!).length == 10
        ? null
        : 'Enter a valid 10-digit number';
  }

  String? validateEmail(String? value) {
    final required = validateRequired(value);
    if (required != null) return required;
    return GetUtils.isEmail(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  void _showApiError(String message) => AppSnackbar.show(
    "Request failed".tr,
    message,
    duration: const Duration(seconds: 4),
  );

  String _apiErrorMessage(Object error, String fallback) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return fallback;
  }

  String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  String _displayGender(String value) => value.isEmpty
      ? ''
      : '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';

  String _displayDate(String value) {
    final date = DateTime.tryParse(value);
    return date == null ? '' : _formatDate(date);
  }

  String _apiDate(String value) {
    final date = _parseDate(value);
    return date == null ? value : _formatApiDate(date);
  }

  DateTime? _parseDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
    final parts = value.split(' ');
    if (parts.length != 3) return null;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months.indexOf(parts[1]);
    if (month < 0) return null;
    return DateTime.tryParse(
      '${parts[2]}-${(month + 1).toString().padLeft(2, '0')}-${parts[0].padLeft(2, '0')}',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1].tr} ${date.year}';
  }

  String _formatApiDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    altPhoneController.dispose();
    super.onClose();
  }
}
