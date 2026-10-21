import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';

class UserStoriesRow extends StatelessWidget {
  final HomeController controller;

  const UserStoriesRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stories = controller.userStories;
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = stories[index];
          if (story.isVideo) {
            return _VideoStoryCard(
              videoPath: story.mediaPath,
              title: story.title,
            );
          }
          return _ImageStoryCard(
            imagePath: story.mediaPath,
            title: story.title,
          );
        },
      ),
    );
  }
}

// ─── Image card (unchanged look) ─────────────────────────────────────────────

class _ImageStoryCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const _ImageStoryCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            _GradientOverlay(),
            _TitleLabel(title: title),
          ],
        ),
      ),
    );
  }
}

// ─── Video card ───────────────────────────────────────────────────────────────

class _VideoStoryCard extends StatelessWidget {
  final String videoPath;
  final String title;
  const _VideoStoryCard({required this.videoPath, required this.title});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => showDialog<void>(
      context: context,
      builder: (_) => _StoryPlayer(videoPath: videoPath),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black87),
            const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 48,
              ),
            ),
            _TitleLabel(title: title),
          ],
        ),
      ),
    ),
  );
}

// Allocate the native player only while the user is viewing a story.
class _StoryPlayer extends StatefulWidget {
  final String videoPath;
  const _StoryPlayer({required this.videoPath});
  @override
  State<_StoryPlayer> createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<_StoryPlayer>
    with WidgetsBindingObserver {
  late final VideoPlayerController _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _ready = true);
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        await _controller.play();
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _controller.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            tooltip: "Close video".tr,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        if (_failed)
          Padding(
            padding: EdgeInsets.all(24),
            child: Text("Unable to play this video.".tr),
          )
        else if (!_ready)
          const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          )
        else
          Flexible(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        if (_ready)
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (_, value, _) => IconButton(
              tooltip: value.isPlaying ? "Pause".tr : "Play".tr,
              icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () =>
                  value.isPlaying ? _controller.pause() : _controller.play(),
            ),
          ),
      ],
    ),
  );
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.65)],
        ),
      ),
    );
  }
}

class _TitleLabel extends StatelessWidget {
  final String title;

  const _TitleLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 12,
      child: Text(
        (title).tr,
        maxLines: 2,
        style: AppTextStyle.bodySmallMedium.copyWith(
          color: Colors.white,
          height: 1.3,
        ),
      ),
    );
  }
}
