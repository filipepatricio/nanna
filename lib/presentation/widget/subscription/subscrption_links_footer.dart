import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
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
          _getChargeInfoText(context, subscriptionPlan),
          textAlign: TextAlign.center,
          style: AppTypography.metadata1Medium.copyWith(color: AppColors.of(context).textSecondary),
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LinkLabel(
              label: context.l10n.subscription_restorePurchase,
              style: AppTypography.metadata1Medium,
              onTap: onRestorePressed,
            ),
            LinkLabel(
              label: context.l10n.settings_termsAndConditions,
              style: AppTypography.metadata1Medium,
              onTap: () => openInBrowser(termsOfServiceUri),
            ),
            LinkLabel(
              label: context.l10n.settings_privacyPolicy,
              style: AppTypography.metadata1Medium,
              onTap: () => openInBrowser(policyPrivacyUri),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}

String _getChargeInfoText(BuildContext context, SubscriptionPlan plan) {
  if (plan.hasTrial) {
    return context.l10n.subscription_chargeInfo_trial(
      context.l10n.date_daySuffix('${plan.trialDays}'),
    );
  } else {
    return context.l10n.subscription_chargeInfo_standard;
  }
}
