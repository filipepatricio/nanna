import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/types.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:flutter/material.dart';

class SubscriptionLinksFooter extends StatelessWidget {
  const SubscriptionLinksFooter({
    required this.subscriptionPlan,
    required this.onRestorePressed,
    required this.openInBrowser,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan subscriptionPlan;
  final VoidCallback onRestorePressed;
  final OpenInBrowserFunction openInBrowser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _getChargeInfoText(subscriptionPlan),
          textAlign: TextAlign.center,
          style: AppTypography.metadata1Medium.copyWith(color: AppColors.textGrey),
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LinkLabel(
              label: LocaleKeys.subscription_restorePurchase.tr(),
              style: AppTypography.metadata1Medium,
              onTap: onRestorePressed,
            ),
            LinkLabel(
              label: LocaleKeys.settings_termsAndConditions.tr(),
              style: AppTypography.metadata1Medium,
              onTap: () => openInBrowser(termsOfServiceUri),
            ),
            LinkLabel(
              label: LocaleKeys.settings_privacyPolicy.tr(),
              style: AppTypography.metadata1Medium,
              onTap: () => openInBrowser(policyPrivacyUri),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }

  String _getChargeInfoText(SubscriptionPlan plan) {
    if (plan.hasTrial) {
      return LocaleKeys.subscription_chargeInfo_trial.tr(
        args: [LocaleKeys.date_day.plural(subscriptionPlan.trialDays)],
      );
    } else {
      return LocaleKeys.subscription_chargeInfo_standard.tr();
    }
  }
}
