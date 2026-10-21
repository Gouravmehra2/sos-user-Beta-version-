import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth =
            width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : null);
        final pixelRatio = MediaQuery.devicePixelRatioOf(context);
        final cacheWidth =
            targetWidth != null && targetWidth.isFinite && targetWidth > 0
            ? (targetWidth * pixelRatio).ceil().clamp(1, 2048)
            : null;
        final Widget image = CachedNetworkImage(
          memCacheWidth: cacheWidth,
          fadeInDuration: Duration.zero,
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (_, __) =>
              placeholder ??
              Container(
                width: width,
                height: height,
                color: Colors.grey.shade100,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          errorWidget: (_, __, ___) =>
              errorWidget ??
              Container(
                width: width,
                height: height,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              ),
        );

        if (borderRadius != null) {
          return ClipRRect(borderRadius: borderRadius!, child: image);
        }
        return image;
      },
    );
  }
}
