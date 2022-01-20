import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StackedCardsErrorView extends HookWidget {
  final double cardStackWidth;
  final EdgeInsets padding;
  final VoidCallback? retryAction;

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
            child: GeneralErrorView(
              title: LocaleKeys.todaysTopics_oops.tr(),
              content: LocaleKeys.todaysTopics_tryAgainLater.tr(),
              svgPath: AppVectorGraphics.sadSun,
              retryCallback: retryAction,
            ),
          );
        },
      ),
    );
  }
}
