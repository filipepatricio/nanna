import 'dart:math';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef StackedCardsRandomBuilder<T> = Widget Function(List<T>);

class StackedCardsRandomVariantBuilder<T> extends HookWidget {
  const StackedCardsRandomVariantBuilder({
    required this.count,
    required this.builder,
    required this.variants,
    this.canNeighboursRepeat = false,
    Key? key,
  }) : super(key: key);

  final StackedCardsRandomBuilder<T> builder;
  final int count;
  final bool canNeighboursRepeat;
  final List<T> variants;

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

  List<T> _randomizeVariants(int seed) {
    final random = Random(seed);
    return canNeighboursRepeat ? _randomizeVariantsWithRepeat(random) : _randomizeVariantsNoRepeat(random).toList();
  }

  List<T> _randomizeVariantsWithRepeat(Random random) {
    return List.generate(count, (index) {
      final randomIndex = random.nextInt(variants.length);
      return variants[randomIndex];
    });
  }

  Iterable<T> _randomizeVariantsNoRepeat(Random random) sync* {
    final variantsCount = variants.length;
    final groupsCount = count / variantsCount + 1;

    List<T>? lastVariantsGroup;
    var availableVariants = variants;

    for (var i = 0; i < groupsCount; i++) {
      final variantsGroup = <T>[];

      if (lastVariantsGroup != null) {
        final lastItemInPreviousGroup = lastVariantsGroup.last;
        final availableFirstVariants = availableVariants.where((value) => value != lastItemInPreviousGroup).toList();
        final firstVariant = availableFirstVariants[random.nextInt(availableFirstVariants.length)];
        availableVariants = availableVariants.where((value) => value != firstVariant).toList();
        variantsGroup.add(firstVariant);
      }

      final iterationsLeft = availableVariants.length;
      for (var i = 0; i < iterationsLeft; i++) {
        final randomIndex = random.nextInt(availableVariants.length);
        final randomVariant = availableVariants[randomIndex];
        availableVariants = availableVariants.where((value) => value != randomVariant).toList();
        variantsGroup.add(randomVariant);
      }

      lastVariantsGroup = variantsGroup;
      availableVariants = variants;
      yield* variantsGroup;
    }
  }
}
