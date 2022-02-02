import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/track/topic_summary_tracker/topic_summary_tracker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _topicSummaryTextStyle = AppTypography.b2MediumLora;

class TopicSummary extends HookWidget {
  final Topic topic;
  final TopicPageCubit cubit;
  final GlobalKey? summaryCardKey;

  const TopicSummary({
    required this.topic,
    required this.cubit,
    this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();
    final topicSummaryTextMaxHeight = AppDimens.topicViewSummaryTextMaxHeight(context);
    final topicSummaryCards = useState(cubit.getTopicSummaryCards(
        topic, _topicSummaryTextStyle, MediaQuery.of(context).size.width, topicSummaryTextMaxHeight));

    if (topic.topicSummaryList.isEmpty) {
      return const SizedBox();
    }

    final content = TopicSummaryTracker(
        topic: topic,
        summaryPageController: controller,
        child: _SummaryCardPageView(
          topic: topic,
          cubit: cubit,
          controller: controller,
          topicSummaryCards: topicSummaryCards.value,
          topicSummaryTextMaxHeight: topicSummaryTextMaxHeight,
          summaryCardKey: summaryCardKey,
        ));

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xl),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Text(
              LocaleKeys.todaysTopics_summaryHeadline.tr(),
              style: AppTypography.h2Jakarta,
            ),
          ),
          const SizedBox(height: AppDimens.sl),
          content,
          if (topicSummaryCards.value.length > 1)
            Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: PageDotIndicator(
                pageCount: topicSummaryCards.value.length,
                controller: controller,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCardPageView extends HookWidget {
  final Topic topic;
  final TopicPageCubit cubit;
  final PageController controller;
  final GlobalKey? summaryCardKey;
  final List<String> topicSummaryCards;
  final double topicSummaryTextMaxHeight;

  const _SummaryCardPageView({
    required this.topic,
    required this.cubit,
    required this.controller,
    required this.topicSummaryCards,
    required this.topicSummaryTextMaxHeight,
    this.summaryCardKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: topicSummaryTextMaxHeight,
        child: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemCount: topicSummaryCards.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: _SummaryCard(
                markdownText: topicSummaryCards[index],
                summaryCardKey: index == 0 ? summaryCardKey : null,
              ),
            );
          },
        ));
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
              baseTextStyle: _topicSummaryTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
