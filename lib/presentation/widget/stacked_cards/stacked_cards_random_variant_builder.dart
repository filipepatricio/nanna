import 'dart:math';

import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef StackedCardsRandomBuilder = Widget Function(List<StackedCardsVariant>);

class StackedCardsRandomVariantBuilder extends HookWidget {
  const StackedCardsRandomVariantBuilder({
    required this.count,
    required this.builder,
    this.canNeighboursRepeat = false,
    Key? key,
  }) : super(key: key);

  final StackedCardsRandomBuilder builder;
  final int count;
  final bool canNeighboursRepeat;

  @override
  Widget build(BuildContext context) {
    final seed = useMemoized(() => Random().nextInt(2 ^ 32), []);
    final cardVariants = useMemoized(() => _randomizeVariants(seed), [count, seed]);

    return builder(cardVariants);
  }

  List<StackedCardsVariant> _randomizeVariants(int seed) {
    final random = Random(seed);
    return canNeighboursRepeat ? _randomizeVariantsWithRepeat(random) : _randomizeVariantsNoRepeat(random).toList();
  }

  List<StackedCardsVariant> _randomizeVariantsWithRepeat(Random random) {
    return List.generate(count, (index) {
      final randomIndex = random.nextInt(StackedCardsVariant.values.length);
      return StackedCardsVariant.values[randomIndex];
    });
  }

  Iterable<StackedCardsVariant> _randomizeVariantsNoRepeat(Random random) sync* {
    final variantsCount = StackedCardsVariant.values.length;
    int? lastVariantIndex;

    for (var i = 0; i < count; i++) {
      var randomIndex = random.nextInt(variantsCount);

      if (randomIndex == lastVariantIndex) {
        randomIndex = (randomIndex + 1) % variantsCount;
      }

      lastVariantIndex = randomIndex;
      yield StackedCardsVariant.values[randomIndex];
    }
  }
}
