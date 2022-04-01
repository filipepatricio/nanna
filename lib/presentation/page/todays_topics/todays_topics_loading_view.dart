import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stack_card_variant.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/stacked_cards_random_variant_builder.dart';
import 'package:flutter/material.dart';

const _itemCount = 2;

class TodaysTopicsLoadingView extends StatelessWidget {
  const TodaysTopicsLoadingView({
    required this.coverSize,
    Key? key,
  }) : super(key: key);

  final Size coverSize;

  @override
  Widget build(BuildContext context) {
    return StackedCardsRandomVariantBuilder<RoundStackCardVariant>(
      count: _itemCount,
      canNeighboursRepeat: false,
      variants: RoundStackCardVariant.values,
      builder: (variants) => Column(
        children: [
          RoundStackedCards.variant(
            coverSize: coverSize,
            variant: variants[0],
            child: const LoadingShimmer.defaultColor(
              radius: AppDimens.m,
            ),
          ),
          const SizedBox(
            height: AppDimens.xxxl,
          ),
          RoundStackedCards.variant(
            coverSize: coverSize,
            variant: variants[0],
            child: const LoadingShimmer.defaultColor(
              radius: AppDimens.m,
            ),
          ),
        ],
      ),
    );
  }
}
