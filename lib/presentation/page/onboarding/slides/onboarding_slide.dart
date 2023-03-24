import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/informed_theme.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    required this.imagePath,
    required this.title,
    required this.body,
    super.key,
  });

  final String imagePath;
  final String title;
  final String body;

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
            flex: 15,
            child: Image.asset(
              imagePath,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppDimens.m),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      title,
                      style: AppTypography.sansTitleLargeLausanne.copyWith(height: 1.14),
                      maxLines: 3,
                      stepGranularity: 0.1,
                    ),
                  ),
                  const SizedBox(height: AppDimens.s),
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      body,
                      style: AppTypography.b2Regular,
                      maxLines: 4,
                      stepGranularity: 0.1,
                    ),
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
