import 'package:get/get.dart';

class DashboardController extends GetxController {
  int selectedIndex = 1;

  void changeIndex({int index = 1}) {
    selectedIndex = index;
    update();
  }
}
