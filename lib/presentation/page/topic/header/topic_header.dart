import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicHeader extends HookWidget {
  const TopicHeader({
    required this.topic,
    required this.onArticlesLabelTap,
    required this.topicHeaderImageHeight,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final double topicHeaderImageHeight;
  final void Function() onArticlesLabelTap;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final screenWidth = MediaQuery.of(context).size.width;

    const coverImageCropHeight = 200.0;
    const coverImageCropWidth = coverImageCropHeight;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Hero(
          tag: topic.heroImage.publicId,
          child: Container(
            width: screenWidth,
            height: topicHeaderImageHeight,
            foregroundDecoration: BoxDecoration(color: AppColors.black.withOpacity(0.4)),
            child: CloudinaryProgressiveImage(
              width: screenWidth,
              height: topicHeaderImageHeight,
              fit: BoxFit.fitWidth,
              testImage: AppRasterGraphics.testArticleHeroImage,
              cloudinaryTransformation: cloudinaryProvider
                  .withPublicIdAsPlatform(topic.heroImage.publicId)
                  .transform()
                  .withLogicalSize(screenWidth, topicHeaderImageHeight, context)
                  .autoGravity(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: AppDimens.topicViewTopicHeaderPadding,
          right: AppDimens.topicViewTopicHeaderPadding * 2.5,
          child: Hero(
            tag: topic.id,
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                color: AppColors.background,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CloudinaryProgressiveImage(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        testImage: AppRasterGraphics.testReadingListCoverImageCropped,
                        cloudinaryTransformation: cloudinaryProvider
                            .withPublicId(topic.coverImage.publicId)
                            .transform()
                            .withLogicalSize(coverImageCropWidth, coverImageCropHeight, context)
                            .crop('crop')
                            .autoGravity(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppDimens.l),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TopicOwnerAvatar(
                            owner: topic.owner,
                            onTap: () => AutoRouter.of(context).push(
                              TopicOwnerPageRoute(owner: topic.owner),
                            ),
                          ),
                          const SizedBox(height: AppDimens.xl),
                          InformedMarkdownBody(
                            markdown: topic.title,
                            baseTextStyle: AppTypography.h1Headline,
                            maxLines: 5,
                          ),
                          const SizedBox(height: AppDimens.xxl),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _SelectedArticlesLabel(onArticlesLabelTap: onArticlesLabelTap, topic: topic),
                              UpdatedLabel(
                                dateTime: topic.lastUpdatedAt,
                                backgroundColor: AppColors.transparent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedArticlesLabel extends StatelessWidget {
  const _SelectedArticlesLabel({
    required this.onArticlesLabelTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final void Function() onArticlesLabelTap;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      onTap: onArticlesLabelTap,
      tapPadding: const EdgeInsets.symmetric(vertical: AppDimens.ml),
      child: Text(
        LocaleKeys.todaysTopics_articles.tr(
          args: [topic.readingList.entries.length.toString()],
        ),
        textAlign: TextAlign.start,
        style: AppTypography.b1Regular.copyWith(decoration: TextDecoration.underline, height: 1),
      ),
    );
  }
}
