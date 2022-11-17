import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicCoverImage extends HookWidget {
  const TopicCoverImage({
    required this.topic,
    required this.borderRadius,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return ClipRRect(
          borderRadius: borderRadius,
          child: CloudinaryImage(
            publicId: topic.heroImage.publicId,
            config: CloudinaryConfig(
              height: height,
              width: width,
            ),
            width: width,
            height: height,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            testImage: AppRasterGraphics.testTopicHeroImage,
          ),
        );
      },
    );
  }
}
