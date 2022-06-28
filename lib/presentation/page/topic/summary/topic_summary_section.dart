import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/track/topic_summary_tracker/topic_summary_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicSummarySection extends HookWidget {
  const TopicSummarySection({
    required this.topic,
    Key? key,
  }) : super(key: key);
  final Topic topic;
  final GlobalKey? summaryCardKey;

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();

    if (!topic.hasSummary) {
      return const SizedBox.shrink();
    }

    final content = TopicSummaryTracker(
      topic: topic,
      summaryPageController: controller,
      child: _SummaryCardPageView(
        topicSummaryList: topic.topicSummaryList,
        controller: controller,
      ),
    );

    return Container(
      width: double.infinity,
      color: AppColors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xxxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Text(
              LocaleKeys.dailyBrief_summaryHeadline.tr(),
              style: AppTypography.h2Regular,
            ),
          ),
          const SizedBox(height: AppDimens.l),
          content,
          if (topic.topicSummaryList.length > 1)
            Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: PageDotIndicator(
                pageCount: topic.topicSummaryList.length,
                controller: controller,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCardPageView extends HookWidget {
  const _SummaryCardPageView({
    required this.topicSummaryList,
    required this.controller,
    Key? key,
  }) : super(key: key);
  final List<TopicSummary> topicSummaryList;
  final PageController controller;
  final GlobalKey? summaryCardKey;

  final List<TopicSummary> topicSummaryList;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.topicViewSummaryTextHeight,
      child: PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: topicSummaryList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: _SummaryCard(
              markdownText: topicSummaryList[index].content,
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.markdownText,
    Key? key,
  }) : super(key: key);
  final String markdownText;
  final GlobalKey? summaryCardKey;

  final String markdownText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InformedMarkdownBody(
            markdown: markdownText,
            baseTextStyle:
                context.isSmallDevice ? AppTypography.b3Regular.copyWith(height: 1.5) : AppTypography.b2Regular,
            pPadding: const EdgeInsets.only(bottom: AppDimens.xs),
          ),
        ),
      ],
    );
  }
}
