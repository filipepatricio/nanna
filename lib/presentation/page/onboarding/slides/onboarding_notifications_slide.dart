import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingNotificationsSlide extends StatelessWidget {
  const OnboardingNotificationsSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(flex: 3),
          Expanded(
              flex: 2,
              child: Text(
                tr(LocaleKeys.onboarding_headerSlideThree),
                style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
              )),
          const Spacer(),
          Expanded(
              flex: 4,
              child: _BulletPointRow(
                header: tr(LocaleKeys.onboarding_notificationBulletPoints_headerOne),
                description: tr(LocaleKeys.onboarding_notificationBulletPoints_descOne),
                icon: AppVectorGraphics.happyGreenSun,
              )),
          const Spacer(),
          Expanded(
              flex: 4,
              child: _BulletPointRow(
                header: tr(LocaleKeys.onboarding_notificationBulletPoints_headerTwo),
                description: tr(LocaleKeys.onboarding_notificationBulletPoints_descTwo),
                icon: AppVectorGraphics.notes,
              )),
          const Spacer(),
          Expanded(
              flex: 4,
              child: _BulletPointRow(
                header: tr(LocaleKeys.onboarding_notificationBulletPoints_headerThree),
                description: tr(LocaleKeys.onboarding_notificationBulletPoints_descThree),
                icon: AppVectorGraphics.megaphone,
              )),
        ],
      ),
    );
  }
}

class _BulletPointRow extends StatelessWidget {
  final String header;
  final String description;
  final String icon;

  const _BulletPointRow({
    required this.header,
    required this.description,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: AppDimens.onboardingIconSize,
          height: AppDimens.onboardingIconSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: AppDimens.l),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: AppTypography.h3Bold16.copyWith(height: 1.5, letterSpacing: 0),
              ),
              Flexible(
                child: AutoSizeText(
                  description,
                  style: AppTypography.b1Regular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
