import 'dart:math';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant.dart';

class StackedCardsVariantRandomizer {
  StackedCardsVariantRandomizer._();

  static final Random _random = Random();

  static StackedCardsVariant get randomVariant {
    if (kIsTest) return StackedCardsVariant.values.first;

    final randomInt = _random.nextInt(StackedCardsVariant.values.length);
    return StackedCardsVariant.values[randomInt];
  }
}
