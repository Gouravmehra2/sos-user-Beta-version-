import 'package:flutter/material.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';

class UserStoriesRow extends StatelessWidget {
  final HomeController controller;

  const UserStoriesRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stories = controller.userStories;
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: stories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = stories[index];
          return _UserStoryCard(
            imagePath: story.imagePath,
            title: story.title,
          );
        },
      ),
    );
  }
}

class _UserStoryCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const _UserStoryCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),

            // Title at bottom
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: Text(
                title,
                maxLines: 2,
                style: AppTextStyle.bodySmallMedium.copyWith(
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
