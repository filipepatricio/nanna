import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class StackedCardsLoadingView extends HookWidget {
  final double cardStackWidth;
  final EdgeInsets padding;
  final String? subtitle;

  const StackedCardsLoadingView({
    required this.cardStackWidth,
    Key? key,
    this.subtitle,
    this.padding = const EdgeInsets.only(
      bottom: AppDimens.c,
      top: AppDimens.xl,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(seconds: 8));
    if (!kIsTest) controller.repeat();

    return Padding(
      padding: padding,
      child: LayoutBuilder(builder: (context, constraints) {
        return PageViewStackedCards.random(
          coverSize: Size(cardStackWidth, constraints.maxHeight),
          centered: true,
          child: Stack(
            children: [
              const Positioned.fill(
                child: LoadingShimmer.defaultColor(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(controller),
                          child: SvgPicture.asset(AppVectorGraphics.sunRays),
                        ),
                        SvgPicture.asset(AppVectorGraphics.happySun),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                  Text(
                    LocaleKeys.todaysTopics_justSec.tr(),
                    style: AppTypography.h3bold,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    subtitle ?? LocaleKeys.todaysTopics_loading.tr(),
                    style: AppTypography.h3Normal,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
