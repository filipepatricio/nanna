import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/informed_theme.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class OnboardingPublishersSlide extends StatelessWidget {
  const OnboardingPublishersSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: InformedTheme.systemUIOverlayStyleDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: AppDimens.safeTopPadding(context),
            color: AppColors.transparent,
          ),
          Expanded(
            flex: 14,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -AppDimens.safeTopPadding(context),
                  bottom: AppDimens.zero,
                  left: AppDimens.zero,
                  right: AppDimens.zero,
                  child: Image.asset(
                    AppRasterGraphics.onboardingPublishers,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.xl),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    context.l10n.onboarding_headerSlideOne,
                    style: AppTypography.onBoardingHeader.copyWith(height: 1.14),
                    maxLines: 3,
                    stepGranularity: 0.1,
                  ),
                  const SizedBox(height: AppDimens.s),
                  AutoSizeText(
                    context.l10n.onboarding_descriptionSlideOne,
                    style: AppTypography.b2Regular,
                    maxLines: 4,
                    stepGranularity: 0.1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
