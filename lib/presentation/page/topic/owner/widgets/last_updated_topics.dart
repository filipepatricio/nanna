import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LastUpdatedTopics extends HookWidget {
  const LastUpdatedTopics({
    required this.topics,
    required this.cardStackHeight,
    Key? key,
  }) : super(key: key);
  final List<TopicPreview> topics;
  final double cardStackHeight;

  @override
  Widget build(BuildContext context) {
    final topicsController = usePageController(viewportFraction: 1.0);
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.xl),
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l),
          child: Text(
            LocaleKeys.topic_owner_lastUpdated.tr(),
            style: AppTypography.h3bold,
          ),
        ),
        const SizedBox(height: AppDimens.s),
        StackedCardsRandomVariantBuilder<StackedCardsVariant>(
          count: topics.length,
          variants: StackedCardsVariant.values,
          canNeighboursRepeat: false,
          builder: (variants) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: cardStackHeight + AppDimens.xl * 2,
                child: PageView.builder(
                  itemCount: topics.length,
                  controller: topicsController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimens.xl),
                      child: GestureDetector(
                        onTap: () => _onTopicTap(context, topics[index]),
                        child: StackedCards.variant(
                          variant: variants[index],
                          coverSize: Size(cardStackWidth, cardStackHeight),
                          child: TopicCover.large(
                            topic: topics[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimens.l),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
                child: PageDotIndicator(
                  pageCount: topics.length,
                  controller: topicsController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _onTopicTap(BuildContext context, TopicPreview topic) {
  AutoRouter.of(context).push(
    TopicPage(
      topicSlug: topic.slug,
    ),
  );
}
