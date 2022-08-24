import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPublishersSlide extends StatelessWidget {
  const OnboardingPublishersSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 13,
          child: Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              AppVectorGraphics.publishersLogo,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.xl),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: AutoSizeText(
                    LocaleKeys.onboarding_headerSlideOne.tr(),
                    style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
                    maxLines: 3,
                    stepGranularity: 0.1,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 10,
                  child: AutoSizeText(
                    LocaleKeys.onboarding_descriptionSlideOne.tr(),
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
    );
  }
}
