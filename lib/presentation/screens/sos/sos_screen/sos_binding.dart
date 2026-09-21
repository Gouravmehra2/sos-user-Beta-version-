import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/sos/sos_screen/sos_controller.dart';

class SosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SosController());
  }
}
