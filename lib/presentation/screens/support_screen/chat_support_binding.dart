import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/support_screen/chat_support_controller.dart';

class ChatSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatSupportController());
  }
}
