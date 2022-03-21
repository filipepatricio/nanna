import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stack_card_variant.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_card_variant_a.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_card_variant_b.dart';
import 'package:flutter/material.dart';

class RoundStackedCards extends StatelessWidget {
  const RoundStackedCards.variant({
    required this.coverSize,
    required this.child,
    required RoundStackCardVariant variant,
    Key? key,
  })  : _variant = variant,
        super(key: key);

  final Size coverSize;
  final Widget child;
  final RoundStackCardVariant _variant;

  @override
  Widget build(BuildContext context) {
    switch (_variant) {
      case RoundStackCardVariant.a:
        return RoundStackedCardVariantA(size: coverSize, child: child);
      case RoundStackCardVariant.b:
        return RoundStackedCardVariantB(size: coverSize, child: child);
    }
  }
}
