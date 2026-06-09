import 'package:flutter/material.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';

class ServiceCategoriesRow extends StatelessWidget {
  final HomeController controller;

  const ServiceCategoriesRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = controller.serviceCategories;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.7,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _ServiceCategoryTile(
            icon: category.icon,
            label: category.label,
            onTap: () => controller.onServiceCategoryTapped(category),
          );
        },
      ),
    );
  }
}

class _ServiceCategoryTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceCategoryTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.neutral2,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color:Color(0xffF2F2F2),width: 1.0),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey1Color.withValues(alpha: 0.15),
              blurRadius: 2,
              offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xfff2f2f2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(icon,height: 24,),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.titleMediumMedium.copyWith(
                  color: AppColor.blackShade1,
                  fontSize: 14, height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColor.brownAccentPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
