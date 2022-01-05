import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/track/topic_summary_tracker/topic_summary_tracker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _summaryPageViewHeight = 275.0;

class TopicSummary extends HookWidget {
  final Topic topic;
  final GlobalKey? summaryCardKey;

  const TopicSummary({
    required this.topic,
    this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(viewportFraction: 0.85);

    if (topic.topicSummaryList.isEmpty) {
      return const SizedBox();
    }

    final content = topic.topicSummaryList.length > 1
        ? TopicSummaryTracker(
            topic: topic,
            summaryPageController: controller,
            child: _SummaryCardPageView(
              topic: topic,
              controller: controller,
              summaryCardKey: summaryCardKey,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: _SummaryCard(index: 0, topic: topic, summaryCardKey: summaryCardKey),
          );

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xl),
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.l),
            child: Text(
              LocaleKeys.todaysTopics_summaryHeadline.tr(),
              style: AppTypography.h2Jakarta,
            ),
          ),
          const SizedBox(height: AppDimens.l),
          content,
          const SizedBox(height: AppDimens.xl),
          if (topic.topicSummaryList.length > 1) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
              child: PageDotIndicator(
                pageCount: topic.topicSummaryList.length,
                controller: controller,
              ),
            ),
            const SizedBox(height: AppDimens.xl),
          ],
        ],
      ),
    );
  }
}

class _SummaryCardPageView extends HookWidget {
  final Topic topic;
  final PageController controller;
  final GlobalKey? summaryCardKey;

  const _SummaryCardPageView({
    required this.topic,
    required this.controller,
    this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _summaryPageViewHeight,
      child: PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: topic.topicSummaryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimens.l),
            child: _SummaryCard(
              topic: topic,
              index: index,
              summaryCardKey: index == 0 ? summaryCardKey : null,
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int index;
  final Topic topic;
  final GlobalKey? summaryCardKey;

  const _SummaryCard({
    required this.index,
    required this.topic,
    required this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: summaryCardKey,
      height: _summaryPageViewHeight,
      padding: const EdgeInsets.only(
        left: AppDimens.l,
        right: AppDimens.l,
        bottom: AppDimens.xl,
      ),
      color: AppColors.pastelGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.xc),
          Expanded(
            child: InformedMarkdownBody(
              markdown: topic.topicSummaryList[index].content,
              baseTextStyle: AppTypography.b2RegularLora,
            ),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}
