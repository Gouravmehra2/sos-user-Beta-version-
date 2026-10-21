import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';

class PaymentMethod {
  final String name;
  final String subtitle;
  final IconData icon;
  PaymentMethod({
    required this.name,
    required this.subtitle,
    required this.icon,
  });
}

class AddMoneyController extends GetxController {
  final amountController = TextEditingController();
  final selectedAmount = RxnInt();
  final selectedMethodIndex = 0.obs;

  final quickAmounts = [500, 2000, 1000, 5000];

  final paymentMethods = [
    PaymentMethod(
      name: 'UPI / GPay',
      subtitle: "Instant Settlement".tr,
      icon: Icons.account_balance_wallet_outlined,
    ),
    PaymentMethod(
      name: 'Visa Card •••• 4492',
      subtitle: "Expires 12/26".tr,
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      name: 'Mastercard •••• 8810',
      subtitle: "Expires 05/25".tr,
      icon: Icons.credit_card,
    ),
  ];

  void selectQuickAmount(int amount) {
    selectedAmount.value = amount;
    amountController.text = amount.toString();
  }

  void proceedToPay() {
    final amount = int.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      AppSnackbar.show("Error".tr, "Please enter a valid amount".tr);
      return;
    }
    AppSnackbar.show(
      "Success".tr,
      "Processing payment of \$@p0".trParams({"p0": (amount).toString()}),
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
