import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_content.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_item.dart';
import 'package:flutter/material.dart';

class StackedCardsVariantC extends StatelessWidget {
  final Size coverSize;
  final Widget child;
  final bool centered;

  const StackedCardsVariantC({
    required this.coverSize,
    required this.centered,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = coverSize.height - coverSize.height / 20 - AppDimens.m;
    final bottomCardWidth = coverSize.width - coverSize.width / 8;

    final topCardHeight = coverSize.height - coverSize.height / 12 - AppDimens.l;
    final topCardWidth = coverSize.width - coverSize.width / 8;

    final middleCardTopMargin = coverSize.height - topCardHeight;
    final middleCardHeight = topCardHeight - middleCardTopMargin;
    const middleCardWidth = 100.0;

    final bottomCardLeftMargin = (coverSize.width - topCardWidth) / 2 + AppDimens.xs;
    final bottomCardRightMargin = coverSize.width - bottomCardLeftMargin - bottomCardWidth;

    final middleCardRightMargin = (coverSize.width - topCardWidth) / 4;
    final middleCardLeftMargin = coverSize.width - middleCardRightMargin - middleCardWidth;

    return Stack(
      children: [
        Container(
          color: AppColors.background,
          width: coverSize.width,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: bottomCardLeftMargin,
          right: bottomCardRightMargin,
          child: StackedCardItem(
            height: bottomCardHeight,
            width: bottomCardWidth,
            centered: centered,
            color: AppColors.darkLinen,
            rotation: -2.9,
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
            rotation: -3.8,
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
