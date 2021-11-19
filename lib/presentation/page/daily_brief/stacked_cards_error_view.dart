import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class StackedCardsErrorView extends HookWidget {
  final double cardStackWidth;

  const StackedCardsErrorView({required this.cardStackWidth, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.c,
        top: AppDimens.xl,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ReadingListStackedCards(
            coverSize: Size(cardStackWidth, constraints.maxHeight),
            center: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppVectorGraphics.sadSun),
                const SizedBox(height: AppDimens.l),
                Text(
                  LocaleKeys.dailyBrief_ups.tr(),
                  style: AppTypography.h3bold,
                  textAlign: TextAlign.center,
                ),
                Text(
                  LocaleKeys.dailyBrief_tryAgainLater.tr(),
                  style: AppTypography.h3Normal,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
