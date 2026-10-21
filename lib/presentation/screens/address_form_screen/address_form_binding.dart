import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/address_form_screen/address_form_controller.dart';

class AddressFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressFormController());
  }
}
