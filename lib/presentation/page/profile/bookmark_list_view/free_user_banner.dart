import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

class FreeUserBanner extends StatelessWidget {
  const FreeUserBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.l),
        decoration: const BoxDecoration(
          color: AppColors.brandAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Take every article with you, wherever you go.',
              textAlign: TextAlign.center,
              style: AppTypography.serifTitleLargeIvar.copyWith(color: AppColors.stateTextPrimary),
            ),
            const SizedBox(height: AppDimens.m),
            Text(
              'Subscribe to informed and every article you save is downloaded to your device for offline reading.',
              textAlign: TextAlign.center,
              style: AppTypography.sansTextSmallLausanne.copyWith(color: AppColors.stateTextPrimary),
            ),
            const SizedBox(height: AppDimens.m),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
              child: InformedFilledButton.color(
                fillColor: AppColors.brandPrimary,
                disableColor: AppColors.brandPrimary,
                textColor: AppColors.brandSecondary,
                text: 'See plans',
                onTap: () => context.pushRoute(const SubscriptionPageRoute()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
