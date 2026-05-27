import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 3),(){
        Get.toNamed(AppRoutes.dashboardScreen);
      });
    },);
    super.onInit();
  }

}