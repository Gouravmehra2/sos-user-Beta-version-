import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/map_picker_screen/map_picker_controller.dart';

class MapPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapPickerController());
  }
}
