import 'package:flutter/material.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';

class PopularServicesRow extends StatelessWidget {
  final String imagePath;
  final String title;
  final String buttonLabel;
  final VoidCallback onBook;

  const PopularServicesRow({
    required this.imagePath,
    required this.title,
    required this.buttonLabel,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowGrey.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Background Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),

            /// Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            /// Favourite Icon
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),

            /// Bottom Content
            Positioned(
              left: 22,
              right: 22,
              bottom: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.titleMediumSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '123 Reviews',
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),

                  const SizedBox(height: 18),

                  InkWell(
                    onTap: onBook,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC58A33),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        buttonLabel,
                        style: AppTextStyle.buttonMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}