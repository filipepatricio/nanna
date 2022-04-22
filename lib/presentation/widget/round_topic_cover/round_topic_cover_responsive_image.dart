import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_progressive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RoundTopicCoverResponsiveImage extends HookWidget {
  const RoundTopicCoverResponsiveImage({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              AppDimens.m,
            ),
          ),
          child: CloudinaryProgressiveImage(
            publicId: topic.coverImage.publicId,
            config: CloudinaryConfig(
              platformBasedExtension: true,
              autoGravity: true,
              height: constraints.maxHeight,
              width: constraints.maxWidth,
            ),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            testImage: AppRasterGraphics.testReadingListCoverImage,
          ),
        );
      },
    );
  }
}
