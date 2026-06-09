import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_controller.dart';

class OnboardingBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}