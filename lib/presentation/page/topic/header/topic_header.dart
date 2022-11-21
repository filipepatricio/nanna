import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/image_top_gradient.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicHeader extends HookWidget {
  const TopicHeader({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final topicHeaderImageHeight = AppDimens.topicViewHeaderImageHeight(context);
    final topicHeaderImageWidth = AppDimens.topicViewHeaderImageWidth(context);

    return SizedBox(
      width: topicHeaderImageWidth,
      height: topicHeaderImageHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: CloudinaryImage(
              publicId: topic.heroImage.publicId,
              config: CloudinaryConfig(
                width: topicHeaderImageWidth,
                height: topicHeaderImageHeight,
              ),
              width: topicHeaderImageWidth,
              height: topicHeaderImageHeight,
              fit: BoxFit.cover,
              testImage: AppRasterGraphics.testArticleHeroImage,
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ImageTopGradient(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: Container(
              color: topic.category.color,
              padding: const EdgeInsets.all(AppDimens.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.h1Headline,
                    textAlignment: TextAlign.center,
                    maxLines: 5,
                  ),
                  const SizedBox(height: AppDimens.m),
                  UpdatedLabel(
                    dateTime: topic.lastUpdatedAt,
                    mode: Brightness.dark,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
