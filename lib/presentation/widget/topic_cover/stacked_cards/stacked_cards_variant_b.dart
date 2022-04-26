import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_background.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_utils.dart';
import 'package:flutter/material.dart';

class StackedCardsVariantB extends StatelessWidget {
  const StackedCardsVariantB({
    required this.size,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = size.height * cardHeightScale;
    final bottomCardWidth = size.width * cardWidthScale;
    final bottomCardHeightDifference = size.height - bottomCardHeight;

    final cornersHeightDiff = calculateCornersHeightDifference(
      angle: 5,
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
          alignment: const Alignment(0.5, 1.0),
          child: StackedCardsBackground(
            height: bottomCardHeight,
            width: bottomCardWidth,
            rotation: 5,
            topMargin: heightDifference,
          ),
        ),
        Center(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: stackedCardsBorder,
              boxShadow: stackedCardsShadows,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
