import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/map_screen/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapController());
  }
}
