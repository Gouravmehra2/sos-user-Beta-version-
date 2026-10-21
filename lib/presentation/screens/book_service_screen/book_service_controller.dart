import 'package:dio/dio.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/widgets/addon_selector.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_controller.dart';

class BookServiceController extends GetxController {
  BookServiceController() {
    addressController.addListener(() {
      final address = selectedAddress.value;
      if (address != null && addressController.text != address.displayAddress) {
        selectedAddress.value = null;
      }
    });
  }

  late ServiceModel service;

  final isLoading = false.obs;
  final isVerifyingPayment = false.obs;
  final isLoadingProfile = false.obs;
  final profileError = ''.obs;
  final formKey = GlobalKey<FormState>();
  final selectedAddonIds = <String>{}.obs;
  final selectedVariant = Rxn<VariantItem>();
  final selectedAddress = Rxn<UserAddress>();
  final bookingForSomeoneElse = false.obs;
  final selectedCountry = CountryCode(
    code: 'US',
    dialCode: '+1',
    name: 'United States',
  ).obs;
  final contactNameController = TextEditingController();
  final alternatePhoneController = TextEditingController();
  bool _changingAddress = false;

  List<AddonItem> get selectedAddons => service.addons
      .where(
        (a) => a.isActive && a.id.isNotEmpty && selectedAddonIds.contains(a.id),
      )
      .toList();
  List<VariantItem> get activeVariants =>
      service.variants.where((v) => v.isActive).toList();

  void toggleAddon(AddonItem addon) {
    if (isLoading.value ||
        addon.id.isEmpty ||
        !service.addons.any((a) => a.id == addon.id && a.isActive)) {
      return;
    }
    if (!selectedAddonIds.add(addon.id)) selectedAddonIds.remove(addon.id);
  }

  Future<void> loadProfile() async {
    if (isLoadingProfile.value) return;
    isLoadingProfile.value = true;
    profileError.value = '';
    try {
      final response = await Get.find<ApiRepo>().meProfile();
      if (isClosed) return;
      selectedAddress.value = response.data.user.defaultAddress;
      addressController.text = selectedAddress.value?.displayAddress ?? '';
      phoneController.text = _phoneForInput(response.data.user.phone);
    } catch (_) {
      if (!isClosed) {
        profileError.value =
            "Unable to load your address and phone. Please retry.".tr;
      }
    } finally {
      if (!isClosed) isLoadingProfile.value = false;
    }
  }

  Future<void> changeAddress() async {
    if (_changingAddress || isLoading.value || isLoadingProfile.value) return;
    _changingAddress = true;
    try {
      final result = await Get.toNamed(
        AppRoutes.selectLocationScreen,
        arguments: {
          'selectionOnly': true,
          'persistDefaultOnSelection': true,
          'returnOnSelection': true,
        },
      );
      if (isClosed) return;
      if (result is UserAddress) {
        selectedAddress.value = result;
        addressController.text = result.displayAddress;
      }
    } finally {
      _changingAddress = false;
    }
  }

  Future<void> enterNewAddress() async {
    if (_changingAddress || isLoading.value) return;
    _changingAddress = true;
    try {
      final result = await Get.toNamed(
        AppRoutes.addressFormScreen,
        arguments: {'checkoutMode': true},
      );
      if (!isClosed && result is UserAddress) {
        selectedAddress.value = result;
        addressController.text = result.displayAddress;
      }
    } finally {
      _changingAddress = false;
    }
  }

  static String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (!RegExp(r'^\+?[0-9 ()-]+$').hasMatch(phone)) {
      return 'Enter a valid phone number';
    }
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length < 7 || digits.length > 15
        ? 'Enter a valid phone number'
        : null;
  }

  void onCountryChanged(CountryCode countryCode) {
    selectedCountry.value = countryCode;
  }

  String formatPhoneNumber(String value) {
    final phone = value.trim();
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    if (phone.startsWith('+')) return '+$digits';
    final dialCode = selectedCountry.value.dialCode ?? '+1';
    return '$dialCode$digits';
  }

  String _phoneForInput(String value) {
    final phone = value.trim();
    final dialCode = selectedCountry.value.dialCode ?? '+1';
    if (phone.startsWith(dialCode)) {
      return phone.substring(dialCode.length).replaceAll(RegExp(r'\D'), '');
    }
    return phone;
  }

  // Form fields
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final instructionsController = TextEditingController();
  final selectedPeriod = 'tomorrow'.obs;
  final serviceDate = DateTime.now().add(const Duration(days: 1)).obs;

  Future<void> selectPeriod(BuildContext context, String period) async {
    if (isLoading.value) return;
    final now = DateTime.now();
    DateTime date;
    if (period == 'today' || period == 'tomorrow') {
      date = now.add(Duration(days: period == 'today' ? 0 : 1));
    } else {
      final lastDate = period == 'week'
          ? DateTime(
              now.year,
              now.month,
              now.day + DateTime.sunday - now.weekday,
            )
          : DateTime(now.year, now.month + 1, 0);
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: lastDate,
      );
      if (picked == null || isClosed || isLoading.value) return;
      date = DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
      );
    }
    selectedPeriod.value = period;
    serviceDate.value = date;
  }

  static const periods = ['today', 'tomorrow', 'week', 'month'];
  static const periodLabels = {
    'today': 'Today',
    'tomorrow': 'Tomorrow',
    'this week': 'week',
    'this month': 'month',
  };

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    service = args is BookingSelection ? args.service : args as ServiceModel;
    if (args is BookingSelection) {
      selectedAddonIds.addAll(
        service.addons
            .where((a) => a.isActive && args.addonIds.contains(a.id))
            .map((a) => a.id),
      );
      selectedVariant.value = activeVariants.firstWhereOrNull(
        (v) => v.id == args.variantId,
      );
    }
    if (service.hasVariants &&
        selectedVariant.value == null &&
        activeVariants.isNotEmpty) {
      selectedVariant.value = activeVariants.first;
    }
    loadProfile();
  }

  @override
  void onClose() {
    contactNameController.dispose();
    alternatePhoneController.dispose();
    addressController.dispose();
    phoneController.dispose();
    instructionsController.dispose();
    super.onClose();
  }

  double get serviceFee =>
      (selectedVariant.value?.offerPrice ?? service.offerPrice).toDouble();
  double get addonsFee =>
      selectedAddons.fold(0, (sum, addon) => sum + addon.price.toDouble());
  int get totalInCents =>
      (serviceFee * 100).round() +
      selectedAddons.fold<int>(
        0,
        (sum, addon) => sum + (addon.price * 100).round(),
      );
  double get subtotal => totalInCents / 100;
  double get total => subtotal;

  bool matchesCheckoutAmount(int amountInCents, String currency) =>
      amountInCents > 0 &&
      amountInCents == totalInCents &&
      currency.toLowerCase() == 'usd';

  Map<String, dynamic> buildBookingPayload() {
    // Build the address field. Spec accepts either a non-empty string or a
    // structured object. Send the full object when we have one so the backend
    // can store structured data; fall back to the plain text string.
    final dynamic addressValue;
    final addr = selectedAddress.value;
    if (addr != null) {
      addressValue = {
        'label': addr.label,
        'name': addr.name,
        'addressLine': addr.addressLine,
        'buildingFloor': addr.house ?? '',
        'street': addr.building ?? '',
        'city': addr.city,
        'state': addr.state,
        'zipcode': addr.zipcode,
        if (addr.latitude != null && addr.longitude != null)
          'coordinates': {'lat': addr.latitude, 'lng': addr.longitude},
      };
    } else {
      // Fallback to the raw text the user typed / loaded.
      addressValue = {
        'addressLine': addressController.text.trim(),
        'city': '',
        'state': '',
        'zipcode': '',
      };
    }

    return {
      'services': [
        {
          'service': service.id,
          'quantity': 1,
          if (selectedVariant.value != null)
            'variantId': selectedVariant.value!.id,
          'addonIds': selectedAddons.map((addon) => addon.id).toList(),
        },
      ],
      'address': addressValue,
      'phone': formatPhoneNumber(
        bookingForSomeoneElse.value
            ? alternatePhoneController.text
            : phoneController.text,
      ),
      if (bookingForSomeoneElse.value) 'bookingForSomeoneElse': true,
      if (bookingForSomeoneElse.value)
        'contactName': contactNameController.text.trim(),
      'serviceDate': serviceDate.value.toUtc().toIso8601String(),
      'specialInstructions': instructionsController.text.trim(),
      // DO NOT send client-calculated totals. The server recalculates prices
      // from its own catalog and sets the PaymentIntent amount authoritatively.
    };
  }

  Future<void> confirmAndBook() async {
    if (isLoading.value ||
        isLoadingProfile.value ||
        profileError.value.isNotEmpty) {
      return;
    }
    if (!(formKey.currentState?.validate() ?? false)) return;
    if ((selectedAddress.value?.addressLine ?? addressController.text)
        .trim()
        .isEmpty) {
      AppSnackbar.show(
        "Enter an address".tr,
        "Choose a saved address or enter a new service address.".tr,
      );
      return;
    }
    if (service.hasVariants && selectedVariant.value == null) {
      AppSnackbar.show(
        "Select a package".tr,
        "Please choose a service package.".tr,
      );
      return;
    }

    isLoading.value = true;
    try {
      final repo = Get.find<ApiRepo>();

      // ── Step 1: POST /bookings ─────────────────────────────────────────
      // Backend recalculates prices and creates a PaymentAttempt + PaymentIntent.
      // No Booking is created yet.
      debugPrint('');
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 1 — POST /bookings                      │');
      debugPrint('│  Service   : ${service.name}');
      debugPrint('│  Variant   : ${selectedVariant.value?.name ?? 'none'}');
      debugPrint(
        '│  Add-ons   : ${selectedAddons.isEmpty ? 'none' : selectedAddons.map((a) => a.name).join(', ')}',
      );
      debugPrint('└─────────────────────────────────────────────────────────┘');

      final attempt = await repo.createBooking(buildBookingPayload());

      // Never open a payment sheet for a different price or currency than
      // the USD total the customer reviewed, including selected add-ons.
      if (!matchesCheckoutAmount(attempt.amountInCents, attempt.currency)) {
        AppSnackbar.show(
          "Price mismatch".tr,
          'The checkout amount does not match your service and add-ons total. '
          'No payment was taken. Please refresh the service prices and try again.',
          duration: const Duration(seconds: 6),
        );
        return;
      }

      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 1 ✓ — PaymentAttempt created            │');
      debugPrint('│  paymentAttemptId      : ${attempt.paymentAttemptId}');
      debugPrint('│  stripePaymentIntentId : ${attempt.stripePaymentIntentId}');
      debugPrint('│  amountInCents         : ${attempt.amountInCents}');
      debugPrint('│  totalAmount           : ${attempt.totalAmount}');
      debugPrint('│  currency              : ${attempt.currency}');
      debugPrint('│  serviceDate           : ${attempt.serviceDate}');
      debugPrint('│  publishableKey        : ${_mask(attempt.publishableKey)}');
      debugPrint('│  clientSecret          : ${_mask(attempt.clientSecret)}');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      // ── Step 2: Configure Stripe SDK ──────────────────────────────────
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 2 — Configuring Stripe SDK              │');
      debugPrint('│  publishableKey : ${_mask(attempt.publishableKey)}');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      Stripe.publishableKey = attempt.publishableKey;
      Stripe.urlScheme = 'squadonsite';
      await Stripe.instance.applySettings();

      debugPrint('│  [PAYMENT] STEP 2 ✓ — applySettings() done');

      // ── Step 3: Init PaymentSheet ─────────────────────────────────────
      // Amount shown on the button comes from the server-authorised
      // PaymentIntent amount, expressed in smallest currency unit.
      final displayAmount = (attempt.amountInCents / 100).toStringAsFixed(2);

      final stripeParams = SetupPaymentSheetParameters(
        merchantDisplayName: 'SquadOnSite',
        paymentIntentClientSecret: attempt.clientSecret,
        returnURL: 'squadonsite://stripe-redirect',
        style: ThemeMode.light,
        // Label uses the server amount — authoritative, not client-estimated.
        primaryButtonLabel: 'Pay \$$displayAmount',
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(primary: Color(0xFF111111)),
          shapes: PaymentSheetShape(borderRadius: 12),
        ),
        billingDetails: BillingDetails(
          name: bookingForSomeoneElse.value
              ? contactNameController.text.trim()
              : null,
          phone: bookingForSomeoneElse.value
              ? formatPhoneNumber(alternatePhoneController.text)
              : formatPhoneNumber(phoneController.text),
        ),
      );

      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 3 — initPaymentSheet                    │');
      debugPrint(
        '│  merchantDisplayName : ${stripeParams.merchantDisplayName}',
      );
      debugPrint('│  primaryButtonLabel  : ${stripeParams.primaryButtonLabel}');
      debugPrint(
        '│  clientSecret        : ${_mask(stripeParams.paymentIntentClientSecret ?? '')}',
      );
      debugPrint(
        '│  billingPhone        : ${stripeParams.billingDetails?.phone ?? 'not set'}',
      );
      debugPrint('└─────────────────────────────────────────────────────────┘');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripeParams,
      );

      debugPrint('│  [PAYMENT] STEP 3 ✓ — initPaymentSheet() done');

      // ── Step 4: Present PaymentSheet ──────────────────────────────────
      // Only proceed to verify if the SDK reports the user completed payment.
      // A StripeException with FailureCode.Canceled means the user dismissed
      // the sheet — do NOT call verify.
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 4 — presentPaymentSheet()               │');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      await Stripe.instance.presentPaymentSheet();
      isVerifyingPayment.value = true;

      debugPrint('│  [PAYMENT] STEP 4 ✓ — User completed payment in sheet');

      // ── Step 5: POST /bookings/verify ─────────────────────────────────
      // Backend verifies with Stripe and ONLY NOW creates the Booking.
      // On 409 the payment is not yet complete — do not clear cart or show success.
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 5 — POST /bookings/verify               │');
      debugPrint('│  paymentAttemptId      : ${attempt.paymentAttemptId}');
      debugPrint('│  stripePaymentIntentId : ${attempt.stripePaymentIntentId}');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      final verified = await repo.verifyBooking(
        paymentAttemptId: attempt.paymentAttemptId,
        stripePaymentIntentId: attempt.stripePaymentIntentId,
      );

      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] STEP 5 ✓ — Booking created by backend        │');
      debugPrint('│  bookingId     : ${verified.bookingId}');
      debugPrint('│  status        : ${verified.status}');
      debugPrint('│  paymentStatus : ${verified.paymentStatus}');
      debugPrint(
        '│  totalAmount   : ${verified.totalAmount} ${verified.paymentProvider.toUpperCase()}',
      );
      debugPrint('│  transactionId : ${verified.transactionId}');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      // ── Step 6: Clear cart — only after verify succeeds ───────────────
      try {
        await repo.clearCart();
        debugPrint('│  [PAYMENT] STEP 6 ✓ — clearCart() done');
      } catch (e) {
        debugPrint(
          '│  [PAYMENT] STEP 6 ✗ — clearCart() failed (non-fatal): $e',
        );
      }

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] ✅ COMPLETE                                   │');
      debugPrint('│  bookingId   : ${verified.bookingId}');
      debugPrint(
        '│  amount      : ${verified.totalAmount} ${verified.paymentProvider}',
      );
      debugPrint('└─────────────────────────────────────────────────────────┘');

      isVerifyingPayment.value = false;
      _showSuccessDialog(verified);
    } on StripeException catch (e) {
      debugPrint('');
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] ❌ StripeException                            │');
      debugPrint('│  code    : ${e.error.code}');
      debugPrint('│  message : ${e.error.localizedMessage}');
      debugPrint('│  type    : ${e.error.type}');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      // Canceled = user dismissed the sheet — silent, no snackbar.
      if (e.error.code != FailureCode.Canceled) {
        AppSnackbar.show(
          "Payment Failed".tr,
          e.error.localizedMessage ??
              "Something went wrong with your payment.".tr,
          duration: const Duration(seconds: 5),
        );
      }
    } on DioException catch (e) {
      debugPrint('');
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] ❌ DioException                               │');
      debugPrint('│  statusCode : ${e.response?.statusCode}');
      debugPrint('│  message    : ${e.message}');
      debugPrint('│  response   : ${e.response?.data}');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      final serverMessage = responseData is Map
          ? responseData['message'] as String? ?? ''
          : '';

      if (statusCode == 409) {
        // Payment not yet confirmed by Stripe — cart must stay intact.
        // User can retry verification; a second checkout must NOT be started.
        AppSnackbar.show(
          "Payment Pending".tr,
          serverMessage.isNotEmpty
              ? serverMessage
              : "Your payment is still being processed. Please wait and try again."
                    .tr,
          duration: const Duration(seconds: 6),
        );
      } else if (statusCode == 400) {
        AppSnackbar.show(
          "Booking Error".tr,
          serverMessage.isNotEmpty
              ? serverMessage
              : "Invalid booking details.".tr,
        );
      } else if (statusCode == 404) {
        AppSnackbar.show(
          "Not Found".tr,
          serverMessage.isNotEmpty
              ? serverMessage
              : "Payment attempt not found.".tr,
        );
      } else {
        // 5xx or unknown — retain checkout state, user can retry.
        AppSnackbar.show(
          "Server Error".tr,
          "Something went wrong on our end. Your payment may still be processing — please check My Bookings before retrying."
              .tr,
          duration: const Duration(seconds: 8),
        );
      }
    } catch (e, stack) {
      debugPrint('');
      debugPrint('┌─────────────────────────────────────────────────────────┐');
      debugPrint('│  [PAYMENT] ❌ Unexpected error                           │');
      debugPrint('│  $e');
      debugPrint('│  $stack');
      debugPrint('└─────────────────────────────────────────────────────────┘');

      AppSnackbar.show("Error".tr, e.toString());
    } finally {
      isVerifyingPayment.value = false;
      isLoading.value = false;
    }
  }

  /// Masks a sensitive string — shows first 6 and last 4 chars only.
  String _mask(String value) {
    if (value.length <= 12) return '***';
    return '${value.substring(0, 6)}...${value.substring(value.length - 4)}';
  }

  void _showSuccessDialog(VerifyBookingResponse verified) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Booking Confirmed!".tr,
                style: AppTextStyle.titleLargeBold.copyWith(
                  color: AppColor.blackColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Payment received. Your booking is pending service confirmation."
                    .tr,
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMediumRegular.copyWith(
                  color: AppColor.coolGrayText,
                  height: 1.5,
                ),
              ),
              // Booking detail pill
              if (verified.bookingId.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: "Booking ID".tr,
                        value: verified.bookingId,
                      ),
                      const SizedBox(height: 6),
                      _DetailRow(
                        label: "Amount Paid".tr,
                        value: '\$${(verified.totalAmount).toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 6),
                      _DetailRow(
                        label: "Status".tr,
                        value: verified.paymentStatus,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.until(
                      (r) => r.settings.name == AppRoutes.dashboardScreen,
                    );
                    Get.find<DashboardController>().changeIndex(
                      index: DashboardController.bookingsIndex,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.blackColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "View My Bookings".tr,
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                    Get.until(
                      (r) => r.settings.name == AppRoutes.dashboardScreen,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.blackColor,
                    side: const BorderSide(color: AppColor.blackColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Go to Home".tr,
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
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

// Small helper for the success dialog detail rows.
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          (label).tr,
          style: AppTextStyle.bodySmallRegular.copyWith(
            color: AppColor.coolGrayText,
          ),
        ),
        Flexible(
          child: Text(
            (value).tr,
            textAlign: TextAlign.end,
            style: AppTextStyle.bodySmallMedium.copyWith(
              color: AppColor.blackShade1,
            ),
          ),
        ),
      ],
    );
  }
}
