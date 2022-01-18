import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadingListCover extends HookWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const ReadingListCover({
    required this.topic,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: kIsTest
                  ? const AssetImage(AppRasterGraphics.testReadingListCoverImage) as ImageProvider
                  : NetworkImage(
                      cloudinaryProvider
                          .withPublicId(topic.coverImage.publicId)
                          .transform()
                          .height(DimensionUtil.getPhysicalPixelsAsInt(constraints.maxHeight, context))
                          .fit()
                          .generateNotNull(),
                    ),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              TopicOwnerAvatar(owner: topic.owner),
              const Spacer(),
              _TopicTitleIntroduction(topic: topic),
              const Spacer(),
              _PublisherLogoRow(topic: topic),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.readingList_articleCount.tr(
                      args: [topic.readingList.entries.length.toString()],
                    ),
                    style: AppTypography.b3Regular.copyWith(decoration: TextDecoration.underline, height: 1),
                  ),
                  const Spacer(),
                  UpdatedLabel(dateTime: topic.lastUpdatedAt, backgroundColor: AppColors.white),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublisherLogoRow extends HookWidget {
  final Topic topic;

  const _PublisherLogoRow({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providers = topic.highlightedPublishers;
    return Row(
      children: [
        ...providers.map(
          (publisher) {
            return PublisherLogo.dark(publisher: publisher);
          },
        ),
      ],
    );
  }
}

class _TopicTitleIntroduction extends StatelessWidget {
  final Topic topic;

  const _TopicTitleIntroduction({required this.topic, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 95,
              child: InformedMarkdownBody(
                markdown: topic.title,
                baseTextStyle: kIsSmallDevice ? AppTypography.h2Bold : AppTypography.h1Bold,
                maxLines: 3,
              ),
            ),
            const Spacer(flex: 12),
            Expanded(
                flex: 120,
                child: InformedMarkdownBody(
                  markdown: topic.introduction,
                  baseTextStyle: kIsSmallDevice ? AppTypography.b3RegularLora : AppTypography.b2RegularLora,
                  maxLines: 5,
                ))
          ],
        ));
  }
}
