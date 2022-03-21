import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_content.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_item.dart';
import 'package:flutter/material.dart';

class StackedCardsVariantA extends StatelessWidget {
  final Size coverSize;
  final Widget child;
  final bool centered;

  const StackedCardsVariantA({
    required this.coverSize,
    required this.centered,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = coverSize.height - coverSize.height / 24 - AppDimens.m;
    final bottomCardWidth = coverSize.width - coverSize.width / 7;

    final topCardHeight = coverSize.height - coverSize.height / 12 - AppDimens.l;
    final topCardWidth = coverSize.width - coverSize.width / 8;

    final middleCardTopMargin = (coverSize.height - topCardHeight) / 2 + AppDimens.l / 2;
    final middleCardHeight = topCardHeight - 10;
    final middleCardWidth = topCardWidth - topCardWidth / 12;

    return Stack(
      children: [
        Container(
          color: AppColors.background,
          width: coverSize.width,
        ),
        StackedCardItem(
          height: bottomCardHeight,
          width: bottomCardWidth,
          centered: centered,
          color: AppColors.darkLinen,
          rotation: -5,
        ),
        Positioned(
          left: centered ? -20 : 0,
          right: 0,
          top: middleCardTopMargin,
          child: StackedCardItem(
            height: middleCardHeight,
            width: middleCardWidth,
            centered: centered,
            color: AppColors.background,
            rotation: -4.1,
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
