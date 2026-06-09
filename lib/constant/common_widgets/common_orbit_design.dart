import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';

class CircularOrbitWidget extends StatefulWidget {
  const CircularOrbitWidget({super.key});

  @override
  State<CircularOrbitWidget> createState() => _CircularOrbitWidgetState();
}

class _CircularOrbitWidgetState extends State<CircularOrbitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<IconData> outerIcons = [
    Icons.desktop_windows_outlined,
    Icons.flash_on_outlined,
    Icons.videocam_outlined,
  ];

  final List<IconData> middleIcons = [
    Icons.laptop_mac_outlined,
    Icons.center_focus_strong,
    Icons.call_split_outlined,
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget orbitItem(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 22,
          color: const Color(0xff111827),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width,
        // height: 400,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                /// OUTER CIRCLE
                Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),

                /// MIDDLE CIRCLE
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),

                /// CENTER LOGO WITH GRADIENT BORDER
                Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(4),
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.brownAccentPrimary.withValues(alpha: 0.60),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 20.0,
                      )
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        AppAssets.appLogoIcon,
                        width: 100,
                        height: 100,
                      ),

                      // OR
                      // child: FlutterLogo(size: 60),
                    ),
                  ),
                ),

                /// OUTER ORBIT
                ...List.generate(
                  outerIcons.length,
                      (index) {
                    final angle =
                        (2 * pi / outerIcons.length) * index +
                            controller.value * 2 * pi;

                    final dx = 175 * cos(angle);
                    final dy = 175 * sin(angle);

                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: orbitItem(
                        outerIcons[index],
                      ),
                    );
                  },
                ),

                /// INNER ORBIT
                ...List.generate(
                  middleIcons.length,
                      (index) {
                    final angle =
                        (2 * pi / middleIcons.length) * index -
                            controller.value * 2 * pi;

                    final dx = 120 * cos(angle);
                    final dy = 120 * sin(angle);

                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: orbitItem(
                        middleIcons[index],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    ).paddingSymmetric(horizontal: 10);
  }
}