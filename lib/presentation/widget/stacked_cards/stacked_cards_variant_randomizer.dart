import 'dart:math';

import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant.dart';

class StackedCardsVariantRandomizer {
  StackedCardsVariantRandomizer._();

  static final Random _random = Random();

  static StackedCardsVariant get randomVariant {
    final randomInt = _random.nextInt(StackedCardsVariant.values.length);
    return StackedCardsVariant.values[randomInt];
  }
}
