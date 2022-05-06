import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/track/topic_summary_tracker/topic_summary_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicSummarySection extends HookWidget {
  final Topic topic;
  final GlobalKey? summaryCardKey;

  const TopicSummarySection({
    required this.topic,
    this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();

    if (!topic.hasSummary) {
      return const SizedBox();
    }

    final content = TopicSummaryTracker(
      topic: topic,
      summaryPageController: controller,
      child: _SummaryCardPageView(
        topicSummaryList: topic.topicSummaryList,
        controller: controller,
        summaryCardKey: summaryCardKey,
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
              LocaleKeys.todaysTopics_summaryHeadline.tr(),
              style: AppTypography.h2Jakarta,
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
  final List<TopicSummary> topicSummaryList;
  final PageController controller;
  final GlobalKey? summaryCardKey;

  const _SummaryCardPageView({
    required this.topicSummaryList,
    required this.controller,
    this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              summaryCardKey: index == 0 ? summaryCardKey : null,
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String markdownText;
  final GlobalKey? summaryCardKey;

  const _SummaryCard({
    required this.markdownText,
    required this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: summaryCardKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InformedMarkdownBody(
              markdown: markdownText,
              baseTextStyle: AppTypography.b2Regular,
              pPadding: const EdgeInsets.only(bottom: AppDimens.xs),
            ),
          ),
        ],
      ),
    );
  }
}
