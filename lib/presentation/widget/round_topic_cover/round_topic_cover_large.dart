import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/round_topic_cover_responsive_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';

class RoundTopicCoverLarge extends StatelessWidget {
  const RoundTopicCoverLarge({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

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
      child: Stack(
        children: [
          RoundTopicCoverResponsiveImage(
            topic: topic,
          ),
          Positioned.fill(
            top: AppDimens.xl,
            bottom: AppDimens.l,
            left: AppDimens.l,
            right: AppDimens.l,
            child: _CoverContent(
              topic: topic,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverContent extends StatelessWidget {
  const _CoverContent({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InformedMarkdownBody(
          markdown: topic.title,
          baseTextStyle: AppTypography.h1ExtraBold,
          maxLines: 4,
        ),
        const SizedBox(height: AppDimens.s),
        UpdatedLabel(
          dateTime: topic.lastUpdatedAt,
        ),
        const Spacer(),
        TopicOwnerAvatar(
          owner: topic.owner,
          withPrefix: true,
          fontSize: 16,
        ),
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
                args: [topic.entryCount.toString()],
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
