import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant_a.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant_b.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant_c.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant_randomizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageViewStackedCards extends HookWidget {
  final Size coverSize;
  final Widget child;
  final bool centered;
  final StackedCardsVariant _variant;

  const PageViewStackedCards.variant({
    required this.coverSize,
    required this.child,
    required StackedCardsVariant variant,
    this.centered = false,
    Key? key,
  })  : _variant = variant,
        super(key: key);

  PageViewStackedCards.random({
    required Size coverSize,
    required Widget child,
    bool centered = false,
  }) : this.variant(
          coverSize: coverSize,
          child: child,
          variant: StackedCardsVariantRandomizer.randomVariant,
          centered: centered,
        );

  @override
  Widget build(BuildContext context) {
    switch (_variant) {
      case StackedCardsVariant.a:
        return StackedCardsVariantA(coverSize: coverSize, centered: centered, child: child);
      case StackedCardsVariant.b:
        return StackedCardsVariantB(coverSize: coverSize, centered: centered, child: child);
      case StackedCardsVariant.c:
        return StackedCardsVariantC(coverSize: coverSize, centered: centered, child: child);
    }
  }
}
