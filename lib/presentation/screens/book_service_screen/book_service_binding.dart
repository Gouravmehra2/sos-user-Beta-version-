import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_controller.dart';

class BookServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookServiceController());
  }
}
