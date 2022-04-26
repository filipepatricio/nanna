import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_progressive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicCoverImage extends HookWidget {
  const TopicCoverImage({
    required this.topic,
    this.showPhoto = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final bool showPhoto;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            color: showPhoto ? AppColors.black40 : null,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: CloudinaryProgressiveImage(
              publicId: showPhoto ? topic.heroImage.publicId : topic.coverImage.publicId,
              config: CloudinaryConfig(
                platformBasedExtension: true,
                autoGravity: true,
                height: height,
                width: width,
              ),
              width: width,
              height: height,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              testImage:
                  showPhoto ? AppRasterGraphics.testArticleHeroImage : AppRasterGraphics.testReadingListCoverImage,
            ),
          ),
        );
      },
    );
  }
}