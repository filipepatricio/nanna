import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_content.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_item.dart';
import 'package:flutter/material.dart';

class StackedCardsVariantB extends StatelessWidget {
  final Size coverSize;
  final Widget child;
  final bool centered;

  const StackedCardsVariantB({
    required this.coverSize,
    required this.centered,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = coverSize.height - coverSize.height / 20 - AppDimens.l;
    final bottomCardWidth = coverSize.width - coverSize.width / 7;

    final topCardHeight = coverSize.height - coverSize.height / 12 - AppDimens.l;
    final topCardWidth = coverSize.width - coverSize.width / 8;

    final middleCardTopMargin = coverSize.height - topCardHeight;
    final middleCardHeight = topCardHeight - middleCardTopMargin;
    const middleCardWidth = 100.0;

    final middleCardRightMargin = (coverSize.width - topCardWidth) / 2 / 2;
    final middleCardLeftMargin = coverSize.width - middleCardRightMargin - middleCardWidth;

    return Stack(
      children: [
        Container(
          color: AppColors.background,
          width: coverSize.width,
        ),
        Positioned(
          top: AppDimens.xl,
          left: 0,
          right: 0,
          child: StackedCardItem(
            height: bottomCardHeight,
            width: bottomCardWidth,
            centered: centered,
            color: AppColors.darkLinen,
            rotation: -3.2,
          ),
        ),
        Positioned(
          top: middleCardTopMargin,
          right: middleCardRightMargin,
          left: middleCardLeftMargin,
          child: StackedCardItem(
            height: middleCardHeight,
            width: middleCardWidth,
            centered: centered,
            color: AppColors.background,
            rotation: -6.2,
          ),
        ),
        StackedCardContent(
          centered: centered,
          width: topCardWidth,
          height: topCardHeight,
          child: child,
        ),
      ],
    );
  }
}
