import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stack_card_variant.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/round_topic_cover_large.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LastUpdatedTopics extends HookWidget {
  final List<Topic> topics;
  final double cardStackHeight;

  const LastUpdatedTopics({
    required this.topics,
    required this.cardStackHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topicsController = usePageController(viewportFraction: 1.0);
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;

    return StackedCardsRandomVariantBuilder<RoundStackCardVariant>(
      count: topics.length,
      variants: RoundStackCardVariant.values,
      canNeighboursRepeat: false,
      builder: (variants) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardStackHeight + AppDimens.xl * 2,
            child: PageView.builder(
              itemCount: topics.length,
              controller: topicsController,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.xl),
                  child: GestureDetector(
                    onTap: () => _onTopicTap(context, topics[index]),
                    child: RoundStackedCards.variant(
                      variant: variants[index],
                      coverSize: Size(cardStackWidth, cardStackHeight),
                      child: RoundTopicCoverLarge(
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
    );
  }
}

void _onTopicTap(BuildContext context, Topic topic) {
  AutoRouter.of(context).push(
    TopicPage(
      topicSlug: topic.id,
      topic: topic,
    ),
  );
}
