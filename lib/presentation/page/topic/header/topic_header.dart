import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/photo_caption/photo_caption_button.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/selected_articles_label.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicHeader extends HookWidget {
  const TopicHeader({
    required this.onArticlesLabelTap,
    required this.onArrowTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final VoidCallback onArticlesLabelTap;
  final VoidCallback onArrowTap;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final topicHeaderImageHeight = AppDimens.topicViewHeaderImageHeight(context);
    final topicHeaderImageWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 0,
          child: SizedBox(
            width: topicHeaderImageWidth,
            height: topicHeaderImageHeight,
            child: CloudinaryImage(
              publicId: topic.heroImage.publicId,
              config: CloudinaryConfig(
                platformBasedExtension: true,
                autoGravity: true,
                width: topicHeaderImageWidth,
                height: topicHeaderImageHeight,
              ),
              width: topicHeaderImageWidth,
              height: topicHeaderImageHeight,
              fit: BoxFit.fitWidth,
              showDarkened: true,
              testImage: AppRasterGraphics.testArticleHeroImage,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(AppDimens.l, kToolbarHeight, AppDimens.l, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 32),
              InformedMarkdownBody(
                markdown: topic.title,
                baseTextStyle: AppTypography.h1Headline(context).copyWith(color: AppColors.white),
                maxLines: 5,
              ),
              const Spacer(flex: 16),
              UpdatedLabel(
                dateTime: topic.lastUpdatedAt,
                mode: Brightness.light,
                fontSize: 16,
              ),
              const Spacer(flex: 208),
              TopicOwnerAvatar(
                withPrefix: true,
                underlined: true,
                owner: topic.owner,
                mode: Brightness.light,
                textStyle: AppTypography.h4Bold,
                onTap: () => AutoRouter.of(context).push(
                  TopicOwnerPageRoute(owner: topic.owner, fromTopicSlug: topic.slug),
                ),
              ),
              const Spacer(flex: 16),
              InformedMarkdownBody(
                markdown: topic.introduction,
                maxLines: 5,
                baseTextStyle:
                    (context.isSmallDevice ? AppTypography.b2MediumLora : AppTypography.b1MediumLora).copyWith(
                  color: AppColors.white,
                ),
              ),
              const Spacer(flex: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PublisherLogoRow(topic: topic.asPreview, mode: Brightness.light),
                  SelectedArticlesLabel(topic: topic, onTap: onArticlesLabelTap),
                ],
              ),
              const SizedBox(height: AppDimens.xl),
              AnimatedPointerDown(
                arrowColor: AppColors.white,
                onTap: onArrowTap,
              ),
              const SizedBox(height: AppDimens.xxl),
              const AudioPlayerBannerPlaceholder(),
            ],
          ),
        ),
        PhotoCaptionButton(
          cloudinaryImage: topic.heroImage,
          topicId: topic.id,
        ),
      ],
    );
  }
}
