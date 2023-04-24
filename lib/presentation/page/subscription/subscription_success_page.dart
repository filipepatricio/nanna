import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SubscriptionSuccessPage extends HookWidget {
  const SubscriptionSuccessPage({
    required this.trialDays,
    required this.reminderDays,
    Key? key,
  }) : super(key: key);

  final int trialDays;
  final int reminderDays;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: AppDimens.c),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.modalRadius),
                      child: SvgPicture.asset(
                        AppVectorGraphics.informedLogoGreen,
                        height: AppDimens.xxxl,
                        width: AppDimens.xxxl,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.m),
                  InformedMarkdownBody(
                    markdown: trialDays > 0
                        ? context.l10n.subscription_success_title_trial(trialDays)
                        : context.l10n.subscription_success_title_standard,
                    textAlignment: TextAlign.start,
                    baseTextStyle: AppTypography.sansTitleLargeLausanne,
                  ),
                  const SizedBox(height: AppDimens.s),
                  Text(
                    trialDays > 0 && reminderDays > 0
                        ? context.l10n.subscription_success_body_trial(reminderDays)
                        : context.l10n.subscription_success_body_standard,
                    textAlign: TextAlign.start,
                    style: AppTypography.sansTextDefaultLausanne.copyWith(color: AppColors.of(context).textSecondary),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: InformedFilledButton.primary(
                      context: context,
                      text: context.l10n.subscription_startReading,
                      onTap: context.popRoute,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xxxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
