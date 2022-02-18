import 'dart:math';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
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
    final seed = useMemoized(() => _getSeed(), []);
    final cardVariants = useMemoized(() => _randomizeVariants(seed), [count, seed]);

    return builder(cardVariants);
  }

  int _getSeed() {
    if (kIsTest) return 0;
    return Random().nextInt(2 ^ 32);
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
    final groupsCount = count / variantsCount + 1;

    List<StackedCardsVariant>? lastVariantsGroup;
    var availableVariants = StackedCardsVariant.values;

    for (var i = 0; i < groupsCount; i++) {
      final variantsGroup = <StackedCardsVariant>[];

      if (lastVariantsGroup != null) {
        final lastItemInPreviousGroup = lastVariantsGroup.last;
        final availableFirstVariants = availableVariants.where((value) => value != lastItemInPreviousGroup).toList();
        final firstVariant = availableFirstVariants[random.nextInt(availableFirstVariants.length)];
        availableVariants = availableVariants.where((value) => value != firstVariant).toList();
        variantsGroup.add(firstVariant);
      }

      final iterationsLeft = availableVariants.length;
      for (var _ = 0; _ < iterationsLeft; _++) {
        final randomIndex = random.nextInt(availableVariants.length);
        final randomVariant = availableVariants[randomIndex];
        availableVariants = availableVariants.where((value) => value != randomVariant).toList();
        variantsGroup.add(randomVariant);
      }

      lastVariantsGroup = variantsGroup;
      availableVariants = StackedCardsVariant.values;
      yield* variantsGroup;
    }
  }
}
