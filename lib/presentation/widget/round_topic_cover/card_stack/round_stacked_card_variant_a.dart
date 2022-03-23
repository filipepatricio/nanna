import 'dart:math';

import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stack_math.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_background_card.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_card_style.dart';
import 'package:flutter/material.dart';

class RoundStackedCardVariantA extends StatelessWidget {
  const RoundStackedCardVariantA({
    required this.size,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = size.height * roundCardHeightScale;
    final bottomCardWidth = size.width * roundCardWidthScale;
    final bottomCardHeightDifference = size.height - bottomCardHeight;

    final cornersHeightDiff = calculateCornersHeightDifference(
      angle: -5,
      leftCorner: const Offset(0, 0),
      rightCorner: Offset(bottomCardWidth, 0),
      origin: Offset(bottomCardWidth / 2, bottomCardHeight / 2),
    );
    final heightDifference = cornersHeightDiff + bottomCardHeightDifference;

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
        ),
        Align(
          alignment: const Alignment(-0.5, 0.0),
          child: RoundStackedBackgroundCard(
            height: bottomCardHeight,
            width: bottomCardWidth,
            rotation: -5,
            topMargin: heightDifference,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: roundedStackedCardsBorder,
              boxShadow: roundedStackedCardsShadow,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
