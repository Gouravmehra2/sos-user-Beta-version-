import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
