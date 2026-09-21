import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/booking_safety_screen/booking_safety_controller.dart';

class BookingSafetyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingSafetyController());
  }
}
