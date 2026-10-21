import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/support_screen/chat_support_controller.dart';

class ChatSupportScreen extends GetView<ChatSupportController> {
  const ChatSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Chat Support',
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Agent info card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.lightGreyColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: const AssetImage(
                    'assets/images/person_image.png',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support Agent',
                      style: AppTextStyle.titleSmallSemiBold.copyWith(
                        color: AppColor.blackShade1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount:
                  controller.messages.length +
                  2 +
                  (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Today, 10:24 AM',
                          style: AppTextStyle.bodySmallRegular.copyWith(
                            color: AppColor.coolGrayText,
                          ),
                        ),
                      ),
                    );
                  }
                  if (controller.isLoadingMore.value &&
                      index == controller.messages.length + 1) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  if (index ==
                      controller.messages.length +
                      (controller.isLoadingMore.value ? 2 : 1)) {
                    return Obx(
                      () => controller.isAgentTyping.value
                          ? _TypingBubble()
                          : const SizedBox.shrink(),
                    );
                  }
                  final msg = controller.messages[index - 1];
                  return _MessageBubble(message: msg);
                },
              ),
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                Obx(() {
                  final isUploading = controller.isUploading.value;
                  final progress = controller.uploadProgress.value;
                  return GestureDetector(
                    onTap: isUploading ? null : controller.pickAndSendMedia,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.lightGreyColor,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: AppColor.coolGrayText,
                              ),
                            ),
                          ),
                          if (isUploading)
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: progress > 0 ? progress : null,
                                color: AppColor.blackColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.coolGrayText,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: controller.pickAndSendMedia,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColor.coolGrayText,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: controller.sendMessage,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppColor.blackColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColor.blackColor,
              child: Text(
                '1A',
                style: AppTextStyle.labelSmallMedium.copyWith(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? AppColor.blackColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: AppColor.lightGreyColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: AppTextStyle.bodyMediumRegular.copyWith(
                          color: isUser ? Colors.white : AppColor.blackShade1,
                          height: 1.5,
                        ),
                      ),
                      if (message.mediaUrl != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              message.messageType.toLowerCase().startsWith(
                                'video',
                              )
                              ? _VideoPreview(url: message.mediaUrl!)
                              : _ImagePreview(url: message.mediaUrl!),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: AppTextStyle.bodySmallRegular.copyWith(
                    color: AppColor.coolGrayText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatefulWidget {
  final String url;

  const _ImagePreview({required this.url});

  @override
  State<_ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<_ImagePreview> {
  int _retryAttempt = 0;
  bool _hasError = false;

  bool get _isValidUrl {
    final uri = Uri.tryParse(widget.url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  void _retry() {
    setState(() {
      _retryAttempt++;
      _hasError = false;
    });
  }

  void _openViewer() {
    if (!_isValidUrl || _hasError) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _FullScreenImageViewer(url: widget.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl || _hasError) {
      return _MediaErrorView(onRetry: _isValidUrl ? _retry : null);
    }

    return GestureDetector(
      onTap: _openViewer,
      child: Image.network(
        widget.url,
        key: ValueKey('${widget.url}-$_retryAttempt'),
        width: 180,
        height: 140,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          final total = loadingProgress.expectedTotalBytes;
          return SizedBox(
            width: 180,
            height: 140,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: total == null
                    ? null
                    : loadingProgress.cumulativeBytesLoaded / total,
              ),
            ),
          );
        },
        errorBuilder: (_, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasError) setState(() => _hasError = true);
          });
          return const SizedBox(
            width: 180,
            height: 140,
            child: Center(child: Icon(Icons.broken_image_outlined)),
          );
        },
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final String url;

  const _FullScreenImageViewer({required this.url});

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  int _retryAttempt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PhotoView(
                key: ValueKey('${widget.url}-$_retryAttempt'),
                imageProvider: NetworkImage(widget.url),
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: _MediaErrorView(
                    foregroundColor: Colors.white,
                    onRetry: () => setState(() => _retryAttempt++),
                  ),
                ),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                enableRotation: false,
                semanticLabel: 'Support attachment image',
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                tooltip: 'Close image',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final Color foregroundColor;
  final String label;

  const _MediaErrorView({
    required this.onRetry,
    this.foregroundColor = AppColor.coolGrayText,
    this.label = 'Image',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: foregroundColor),
          const SizedBox(height: 6),
          Text(
            onRetry == null ? '$label unavailable' : 'Could not load $label',
            textAlign: TextAlign.center,
            style: TextStyle(color: foregroundColor, fontSize: 12),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text('Retry', style: TextStyle(color: foregroundColor)),
            ),
        ],
      ),
    );
  }
}

class _VideoPreview extends StatelessWidget {
  final String url;
  const _VideoPreview({required this.url});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      return const _MediaErrorView(label: 'Video', onRetry: null);
    }
    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) => _FullScreenVideoViewer(url: url),
      ),
      child: const SizedBox(
        width: 180,
        height: 100,
        child: ColoredBox(
          color: Colors.black87,
          child: Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenVideoViewer extends StatefulWidget {
  final String url;

  const _FullScreenVideoViewer({required this.url});

  @override
  State<_FullScreenVideoViewer> createState() => _FullScreenVideoViewerState();
}

class _FullScreenVideoViewerState extends State<_FullScreenVideoViewer>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  String? _error;

  bool get _isValidUrl {
    final uri = Uri.tryParse(widget.url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    if (!_isValidUrl) {
      if (mounted) setState(() => _error = 'Video unavailable');
      return;
    }
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      await controller.dispose();
      if (mounted) setState(() => _error = 'Could not load video');
    }
  }

  void _retry() {
    _controller?.dispose();
    setState(() {
      _controller = null;
      _error = null;
    });
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: controller != null && controller.value.isInitialized
                  ? ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: controller,
                      builder: (context, value, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: value.aspectRatio > 0
                                      ? value.aspectRatio
                                      : 16 / 9,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                              child: Column(
                                children: [
                                  VideoProgressIndicator(
                                    controller,
                                    allowScrubbing: true,
                                    colors: const VideoProgressColors(
                                      playedColor: Colors.white,
                                      bufferedColor: Colors.white54,
                                      backgroundColor: Colors.white24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: value.isPlaying
                                            ? 'Pause'
                                            : 'Play',
                                        onPressed: () {
                                          value.isPlaying
                                              ? controller.pause()
                                              : controller.play();
                                        },
                                        icon: Icon(
                                          value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: _error == null
                          ? const CircularProgressIndicator(color: Colors.white)
                          : _MediaErrorView(
                              foregroundColor: Colors.white,
                              onRetry: _isValidUrl ? _retry : null,
                              label: 'Video',
                            ),
                    ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                tooltip: 'Close video',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _controller?.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }
}

class _TypingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColor.blackColor,
            child: Text(
              '1A',
              style: AppTextStyle.labelSmallMedium.copyWith(
                color: Colors.white,
                fontSize: 9,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColor.lightGreyColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColor.coolGrayText,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
