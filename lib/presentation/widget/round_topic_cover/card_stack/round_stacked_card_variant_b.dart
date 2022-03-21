import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_background_card.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_card_style.dart';
import 'package:flutter/material.dart';

class RoundStackedCardVariantB extends StatelessWidget {
  const RoundStackedCardVariantB({
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
    final bottomCardTopMargin = (size.height - bottomCardHeight) * 0.75;

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
        ),
        Align(
          alignment: const Alignment(0.75, 0),
          child: RoundStackedBackgroundCard(
            height: bottomCardHeight,
            width: bottomCardWidth,
            margins: EdgeInsets.only(top: bottomCardTopMargin),
            rotation: 5,
          ),
        ),
        Center(
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
