import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_controller.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_screen.dart';

class TermsConditionsController extends PrivacyPolicyController {
  TermsConditionsController()
    : super(
        documentAsset: 'assets/html/terms_conditions.html',
        documentName: 'terms and conditions',
      );
}

class TermsConditionsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => TermsConditionsController());
}

class TermsConditionsScreen extends GetView<TermsConditionsController> {
  const TermsConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) => PolicyDocumentView(
    controller: controller,
    title: "profile_settings_terms".tr,
    icon: Icons.gavel_outlined,
  );
}
