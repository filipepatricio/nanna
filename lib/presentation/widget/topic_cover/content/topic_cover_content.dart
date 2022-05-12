import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';

class TopicCoverContent extends StatelessWidget {
  const TopicCoverContent({
    required this.topic,
    required this.type,
    this.mode = Brightness.dark,
    this.hasBackgroundColor = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final Brightness mode;
  final bool hasBackgroundColor;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.large:
        return _CoverContentLarge(topic: topic, mode: mode);
      case TopicCoverType.small:
        return _CoverContentSmall(topic: topic, mode: mode);
      case TopicCoverType.exploreLarge:
        return _CoverContentExploreLarge(topic: topic);
      case TopicCoverType.exploreSmall:
        return _CoverContentExploreSmall(topic: topic, hasBackgroundColor: hasBackgroundColor);
    }
  }
}

class _CoverContentLarge extends StatelessWidget {
  const _CoverContentLarge({
    required this.topic,
    required this.mode,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final Brightness mode;

  bool get darkMode => mode == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: AppDimens.xl,
      bottom: AppDimens.l,
      left: AppDimens.l,
      right: AppDimens.l,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InformedMarkdownBody(
            markdown: topic.title,
            baseTextStyle: AppTypography.h1ExtraBold.copyWith(
              color: darkMode ? null : AppColors.white,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: AppDimens.s),
          UpdatedLabel(
            dateTime: topic.lastUpdatedAt,
            mode: mode,
          ),
          const Spacer(),
          TopicOwnerAvatar(
            owner: topic.owner,
            withPrefix: true,
            underlined: true,
            mode: mode,
            textStyle: AppTypography.h4Bold,
            onTap: () => AutoRouter.of(context).push(
              TopicOwnerPageRoute(owner: topic.owner, fromTopicSlug: topic.slug),
            ),
          ),
          const SizedBox(height: AppDimens.s),
          InformedMarkdownBody(
            markdown: topic.introduction,
            baseTextStyle: AppTypography.b3MediumLora.copyWith(
              color: darkMode ? null : AppColors.white,
            ),
            maxLines: 5,
          ),
          const SizedBox(height: AppDimens.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PublisherLogoRow(
                topic: topic,
                mode: mode,
              ),
              const Spacer(),
              Text(
                LocaleKeys.readingList_articleCount.tr(
                  args: [topic.entryCount.toString()],
                ),
                style: AppTypography.b3Regular.copyWith(
                  height: 1.5,
                  color: darkMode ? null : AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverContentExploreLarge extends StatelessWidget {
  const _CoverContentExploreLarge({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: AppDimens.m,
      bottom: AppDimens.l,
      left: AppDimens.m,
      right: AppDimens.l,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoverLabel.topic(topic: topic),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: topic.title,
            maxLines: 4,
            baseTextStyle: AppTypography.h1ExtraBold.copyWith(
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppDimens.s),
          UpdatedLabel(
            mode: Brightness.light,
            dateTime: topic.lastUpdatedAt,
          ),
        ],
      ),
    );
  }
}

class _CoverContentSmall extends StatelessWidget {
  const _CoverContentSmall({
    required this.topic,
    required this.mode,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final Brightness mode;

  bool get darkMode => mode == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppDimens.m,
      bottom: AppDimens.m,
      right: AppDimens.m,
      left: AppDimens.m,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InformedMarkdownBody(
            markdown: topic.title,
            baseTextStyle: AppTypography.h4ExtraBold.copyWith(
              color: darkMode ? null : AppColors.white,
            ),
            maxLines: 4,
          ),
          const Spacer(),
          TopicOwnerAvatar(
            owner: topic.owner,
            withPrefix: true,
            imageSize: AppDimens.l,
            fontSize: 14,
            mode: mode,
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.readingList_articleCount.tr(
              args: [topic.entryCount.toString()],
            ),
            style: AppTypography.b3Regular.copyWith(
              height: 1.5,
              color: darkMode ? null : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverContentExploreSmall extends StatelessWidget {
  const _CoverContentExploreSmall({
    required this.topic,
    this.hasBackgroundColor = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final bool hasBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        TopicOwnerAvatar(
          owner: topic.owner,
          withImage: false,
          imageSize: AppDimens.zero,
          textStyle: AppTypography.metadata1Regular.copyWith(height: 1.2),
          mode: Brightness.dark,
        ),
        const SizedBox(height: AppDimens.s),
        InformedMarkdownBody(
          markdown: topic.title,
          maxLines: 2,
          baseTextStyle: AppTypography.metadata1ExtraBold,
        ),
        const SizedBox(height: AppDimens.s),
        UpdatedLabel(
          dateTime: topic.lastUpdatedAt,
          mode: Brightness.dark,
          textStyle: AppTypography.metadata1Regular.copyWith(
            height: 1.2,
            color: hasBackgroundColor ? null : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
