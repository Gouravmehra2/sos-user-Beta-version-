import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/service_review_screen/service_review_controller.dart';

class ServiceReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceReviewController());
  }
}
