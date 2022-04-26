import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant_a.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant_b.dart';
import 'package:flutter/material.dart';

class StackedCards extends StatelessWidget {
  const StackedCards.variant({
    required this.coverSize,
    required this.child,
    required StackedCardsVariant variant,
    Key? key,
  })  : _variant = variant,
        super(key: key);

  final Size coverSize;
  final Widget child;
  final StackedCardsVariant _variant;

  @override
  Widget build(BuildContext context) {
    switch (_variant) {
      case StackedCardsVariant.a:
        return StackedCardsVariantA(size: coverSize, child: child);
      case StackedCardsVariant.b:
        return StackedCardsVariantB(size: coverSize, child: child);
    }
  }
}
