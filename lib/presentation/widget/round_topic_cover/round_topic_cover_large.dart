import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RoundTopicCoverLarge extends StatelessWidget {
  const RoundTopicCoverLarge({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            AppDimens.m,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.l,
          ) +
          const EdgeInsets.only(
            top: AppDimens.xl,
            bottom: AppDimens.l,
          ),
      child: Stack(
        children: [
          _CoverImage(topic: topic),
          Positioned.fill(
            child: _CoverContent(
              topic: topic,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends HookWidget {
  const _CoverImage({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();

    return LayoutBuilder(
      builder: (context, constraints) {
        return CloudinaryProgressiveImage(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          testImage: AppRasterGraphics.testReadingListCoverImage,
          cloudinaryTransformation: cloudinaryProvider
              .withPublicId(topic.coverImage.publicId)
              .transform()
              .height(DimensionUtil.getPhysicalPixelsAsInt(constraints.maxHeight, context))
              .fit(),
        );
      },
    );
  }
}

class _CoverContent extends StatelessWidget {
  const _CoverContent({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InformedMarkdownBody(
          markdown: topic.title,
          baseTextStyle: AppTypography.h1ExtraBold,
          maxLines: 2,
        ),
        const SizedBox(height: AppDimens.s),
        UpdatedLabel(
          dateTime: topic.lastUpdatedAt,
        ),
        const Spacer(),
        TopicOwnerAvatar(owner: topic.owner, withPrefix: true),
        const SizedBox(height: AppDimens.s),
        InformedMarkdownBody(
          markdown: topic.introduction,
          baseTextStyle: AppTypography.b3MediumLora,
          maxLines: 5,
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PublisherLogoRow(topic: topic),
            const Spacer(),
            Text(
              LocaleKeys.readingList_articleCount.tr(
                args: [topic.readingList.entries.length.toString()],
              ),
              style: AppTypography.b3Regular.copyWith(
                height: 1.5,
                letterSpacing: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
