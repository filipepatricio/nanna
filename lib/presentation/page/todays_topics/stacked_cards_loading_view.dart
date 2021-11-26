import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class StackedCardsLoadingView extends HookWidget {
  final double cardStackWidth;

  const StackedCardsLoadingView({required this.cardStackWidth, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(seconds: 8));
    controller.repeat();

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.c,
        top: AppDimens.xl,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return ReadingListStackedCards(
          coverSize: Size(cardStackWidth, constraints.maxHeight),
          center: true,
          child: Stack(
            children: [
              Positioned.fill(
                child: Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: AppColors.background,
                  highlightColor: AppColors.pastelGreen.withOpacity(0.8),
                  child: Container(color: AppColors.background),
                ),
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
                    LocaleKeys.todaysTopics_loading.tr(),
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
