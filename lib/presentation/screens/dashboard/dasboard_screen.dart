import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/dashboard/widgets/custom_bottom_navigation_tab.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_screen.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/presentation/screens/splash_screen/splash_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: DashboardController(),
        builder: (controller) {
          return IndexedStack(index: controller.selectedIndex, children: [
            HomeScreen(),
            SplashScreen(),
            SplashScreen(),
            ProfileScreen(),
          ]);
        },
      ),
      bottomNavigationBar: GetBuilder(
        init: DashboardController(),
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(controller.bottomList.length, (index) {
                return AnimatedBottomNavItem(
                  item: controller.bottomList[index],
                  isSelected: controller.selectedIndex == index,
                  onTap: () {
                    controller.changeIndex(index: index);
                  },
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

