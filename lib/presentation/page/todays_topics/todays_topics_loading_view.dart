import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
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
    return StackedCardsRandomVariantBuilder<StackedCardsVariant>(
      count: _itemCount,
      canNeighboursRepeat: false,
      variants: StackedCardsVariant.values,
      builder: (variants) => Column(
        children: [
          StackedCards.variant(
            coverSize: coverSize,
            variant: variants[0],
            child: const LoadingShimmer.defaultColor(
              radius: AppDimens.m,
            ),
          ),
          const SizedBox(
            height: AppDimens.xxxl,
          ),
          StackedCards.variant(
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
