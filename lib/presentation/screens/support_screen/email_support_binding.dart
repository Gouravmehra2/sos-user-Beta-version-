import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/support_screen/email_support_controller.dart';

class EmailSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailSupportController());
  }
}
