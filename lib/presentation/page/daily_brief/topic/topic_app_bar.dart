import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TopicAppBar extends StatelessWidget {
  final String title;
  final double backgroundAnimationFactor;
  final double foregroundAnimationFactor;
  final double elevation;
  final double? progress;
  final Animation<double>? fadeAnimation;

  const TopicAppBar({
    required this.title,
    required this.backgroundAnimationFactor,
    required this.foregroundAnimationFactor,
    this.elevation = 3.0,
    this.progress,
    this.fadeAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final whiteToBlack = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);
    final transparentToWhite = ColorTween(begin: AppColors.transparent, end: AppColors.background);

    final progress = this.progress;
    final fadeAnimation = this.fadeAnimation;

    return AppBar(
      backgroundColor: transparentToWhite.transform(backgroundAnimationFactor),
      elevation: elevation,
      shadowColor: AppColors.black.withOpacity(0.4),
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: backgroundAnimationFactor >= 0.5 ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      centerTitle: false,
      title: Row(
        children: [
          IconButton(
            onPressed: () => AutoRouter.of(context).pop(),
            icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                AppVectorGraphics.arrowRight,
                height: AppDimens.backArrowSize,
                color: whiteToBlack.transform(foregroundAnimationFactor),
              ),
            ),
          ),
          Hero(
            tag: HeroTag.dailyBriefTitle,
            child: Text(
              title,
              style: AppTypography.h1Bold.copyWith(color: whiteToBlack.transform(foregroundAnimationFactor)),
            ),
          ),
          const SizedBox(width: AppDimens.m),
          if (progress != null && fadeAnimation != null)
            Expanded(
              child: _Progress(
                progress: progress,
                fadeAnimation: fadeAnimation,
              ),
            ),
          const SizedBox(width: AppDimens.l),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  final double progress;
  final Animation<double> fadeAnimation;

  const _Progress({
    required this.progress,
    required this.fadeAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: LinearPercentIndicator(
        lineHeight: AppDimens.xs,
        percent: progress,
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 300,
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: AppColors.grey.withOpacity(0.44),
        progressColor: AppColors.limeGreen,
      ),
    );
  }
}
