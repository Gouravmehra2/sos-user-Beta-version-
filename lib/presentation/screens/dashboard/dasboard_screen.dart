import 'package:squadonsite/presentation/screens/plans_screen/plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/dashboard/widgets/custom_bottom_navigation_tab.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_screen.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_screen.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Map<int, Widget> _tabs = {};

  Widget _tab(int index) => _tabs.putIfAbsent(
    index,
    () => switch (index) {
      0 => const HomeScreen(),
      1 => ServiceScreen(),
      2 => const PlansScreen(),
      3 => const BookingHistoryScreen(),
      4 => ProfileScreen(),
      _ => const HomeScreen(),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          _tab(controller.selectedIndex);
          return IndexedStack(
            index: controller.selectedIndex,
            children: List.generate(
              controller.bottomList.length,
              (index) => TickerMode(
                enabled: index == controller.selectedIndex,
                child: _tabs[index] ?? const SizedBox.shrink(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<DashboardController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(controller.bottomList.length, (
                      index,
                    ) {
                      return AnimatedBottomNavItem(
                        item: controller.bottomList[index],
                        isSelected: controller.selectedIndex == index,
                        onTap: () => controller.changeIndex(index: index),
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
