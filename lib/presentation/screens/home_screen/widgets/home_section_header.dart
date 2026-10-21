import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_controller.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final double? fontSize;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.fontSize,
  });

  static const _categories = [
    (title: 'PC', description: 'Repair & care', icon: Icons.computer_outlined),
    (
      title: 'Printer',
      description: 'Setup & repair',
      icon: Icons.print_outlined,
    ),
    (
      title: 'Home Appliances',
      description: 'Repair',
      icon: Icons.home_work_outlined,
    ),
    (
      title: 'Networking',
      description: 'Network Setup',
      icon: Icons.router_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = constraints.maxWidth < 360 ? 10.0 : 8.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;
        final scale = (cardWidth / 350).clamp(0.45, 1.0);
        final iconSize = 90.0 * scale;
        final padding = 15.0 * scale;
        final iconGap = 15.0 * scale;
        final chevronSize = 45.0 * scale;
        final textStyle = TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize ?? 26.0 * scale,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -0.2,
          color: Colors.black,
        );
        final descriptionStyle = TextStyle(
          fontFamily: 'Inter',
          fontSize: 17.0 * scale,
          fontWeight: FontWeight.w400,
          height: 1.3,
          color: const Color(0xFF454545),
        );
        final availableTextWidth =
            (cardWidth - padding * 2 - iconSize - iconGap - chevronSize - 2 - 2)
                .clamp(1.0, double.infinity);
        var contentHeight = iconSize;
        for (final category in _categories) {
          final titlePainter = TextPainter(
            text: TextSpan(text: category.title, style: textStyle),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout(maxWidth: availableTextWidth);
          final subtitlePainter = TextPainter(
            text: TextSpan(text: category.description, style: descriptionStyle),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout(maxWidth: availableTextWidth);
          final textHeight = titlePainter.height + 4 + subtitlePainter.height;
          if (textHeight > contentHeight) contentHeight = textHeight;
          titlePainter.dispose();
          subtitlePainter.dispose();
        }
        final height = (contentHeight + padding * 2 + 2).clamp(
          76.0,
          double.infinity,
        );

        Widget card(int index) => _buildCard(
          index,
          height: height,
          iconSize: iconSize,
          iconGap: iconGap,
          chevronSize: chevronSize,
          padding: padding,
          textStyle: textStyle,
          descriptionStyle: descriptionStyle,
        );

        return Column(
          children: [
            for (var row = 0; row < 2; row++) ...[
              if (row > 0) SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: card(row * 2)),
                    SizedBox(width: gap),
                    Expanded(child: card(row * 2 + 1)),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCard(
    int index, {
    required double height,
    required double iconSize,
    required double iconGap,
    required double chevronSize,
    required double padding,
    required TextStyle textStyle,
    required TextStyle descriptionStyle,
  }) {
    final category = _categories[index];
    final radius = BorderRadius.circular(50);
    final icon = Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        shape: BoxShape.circle,
      ),
      child: Icon(category.icon, size: iconSize * 0.52, color: Colors.black),
    );
    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.title, softWrap: true, style: textStyle),
        const SizedBox(height: 4),
        Text(category.description, softWrap: true, style: descriptionStyle),
      ],
    );
    final chevron = Container(
      width: chevronSize,
      height: chevronSize,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.chevron_right_rounded,
        size: chevronSize * 0.65,
        color: Colors.black,
      ),
    );

    return Container(
      constraints: BoxConstraints(minHeight: height),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Get.find<DashboardController>().openServiceCategory(
              title: category.title,
              categoryId: kCategoryIds[category.title] ?? '',
            );
          },
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                icon,
                SizedBox(width: iconGap),
                Expanded(child: text),
                const SizedBox(width: 2),
                chevron,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
