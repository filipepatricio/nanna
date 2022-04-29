import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingTrackingSlide extends StatelessWidget {
  const OnboardingTrackingSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(flex: 2),
          Expanded(
            flex: 3,
            child: Text(
              tr(LocaleKeys.onboarding_tracking_title),
              style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppVectorGraphics.tracking,
                  width: AppDimens.onboardingIconSize,
                  height: AppDimens.onboardingIconSize,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppDimens.l),
                Flexible(
                  child: Text(
                    tr(LocaleKeys.onboarding_tracking_info),
                    style: AppTypography.b2Regular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
