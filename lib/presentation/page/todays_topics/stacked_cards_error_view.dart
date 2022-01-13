import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class StackedCardsErrorView extends HookWidget {
  final double cardStackWidth;
  final EdgeInsets padding;
  final Function? retryAction;

  const StackedCardsErrorView({
    required this.cardStackWidth,
    this.retryAction,
    Key? key,
    this.padding = const EdgeInsets.only(
      bottom: AppDimens.c,
      top: AppDimens.xl,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PageViewStackedCards.random(
            coverSize: Size(cardStackWidth, constraints.maxHeight),
            centered: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppVectorGraphics.sadSun),
                const SizedBox(height: AppDimens.l),
                Text(
                  LocaleKeys.todaysTopics_oops.tr(),
                  style: AppTypography.h3bold,
                  textAlign: TextAlign.center,
                ),
                Text(
                  LocaleKeys.todaysTopics_tryAgainLater.tr(),
                  style: AppTypography.h3Normal,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.l),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
                  child: retryAction != null
                      ? FilledButton(
                          text: LocaleKeys.common_tryAgain.tr(),
                          fillColor: AppColors.textPrimary,
                          textColor: AppColors.white,
                          onTap: () async {
                            await retryAction!();
                          },
                        )
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
