import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
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
    final cloudinaryProvider = useCloudinaryProvider();
    final topicHeaderImageHeight = AppDimens.topicViewHeaderImageHeight(context);
    final topicHeaderImageWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 0,
          child: Container(
            width: topicHeaderImageWidth,
            height: topicHeaderImageHeight,
            foregroundDecoration: BoxDecoration(color: AppColors.black.withOpacity(0.4)),
            child: CloudinaryProgressiveImage(
              width: topicHeaderImageWidth,
              height: topicHeaderImageHeight,
              fit: BoxFit.fitWidth,
              testImage: AppRasterGraphics.testArticleHeroImage,
              cloudinaryTransformation: cloudinaryProvider
                  .withPublicIdAsPlatform(topic.heroImage.publicId)
                  .transform()
                  .withLogicalSize(topicHeaderImageWidth, topicHeaderImageHeight, context)
                  .autoGravity(),
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
              const Spacer(flex: 42),
              TopicOwnerAvatar(
                owner: topic.owner,
                mode: Brightness.light,
                underlined: true,
                onTap: () => AutoRouter.of(context).push(
                  TopicOwnerPageRoute(owner: topic.owner),
                ),
              ),
              const Spacer(flex: 16),
              InformedMarkdownBody(
                markdown: topic.title,
                baseTextStyle: AppTypography.h1Headline(context).copyWith(color: AppColors.white),
                maxLines: 5,
              ),
              const Spacer(flex: 291),
              InformedMarkdownBody(
                markdown: topic.introduction,
                baseTextStyle:
                    (context.isSmallDevice ? AppTypography.b3RegularLora : AppTypography.b2RegularLora).copyWith(
                  color: AppColors.white,
                ),
                maxLines: 5,
              ),
              const Spacer(flex: 24),
              PublisherLogoRow(
                topic: topic,
                mode: Brightness.light,
              ),
              const Spacer(flex: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectedArticlesLabel(onArticlesLabelTap: onArticlesLabelTap, topic: topic),
                  UpdatedLabel(
                    dateTime: topic.lastUpdatedAt,
                    mode: Brightness.light,
                    backgroundColor: AppColors.transparent,
                  ),
                ],
              ),
              const Spacer(flex: 32),
              AnimatedPointerDown(arrowColor: AppColors.white, onTap: onArrowTap),
              const Spacer(flex: 40),
            ],
          ),
        ),
      ],
    );
  }
}
