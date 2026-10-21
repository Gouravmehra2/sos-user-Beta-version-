import 'package:get/get.dart';
import 'booking_history_controller.dart';

class BookingHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingHistoryController>(() => BookingHistoryController());
  }
}
