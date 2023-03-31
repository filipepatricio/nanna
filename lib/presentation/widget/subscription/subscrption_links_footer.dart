import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

class SubscriptionLinksFooter extends StatelessWidget {
  const SubscriptionLinksFooter({
    required this.subscriptionPlan,
    required this.onRestorePressed,
    required this.onRedeemCode,
    required this.openInBrowser,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan subscriptionPlan;
  final VoidCallback onRestorePressed;
  final VoidCallback onRedeemCode;
  final OpenInBrowserFunction openInBrowser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: InformedFilledButton.tertiary(
                context: context,
                text: context.l10n.subscription_redeemCode,
                withOutline: true,
                onTap: onRedeemCode,
              ),
            ),
            const SizedBox(width: AppDimens.s),
            Expanded(
              child: InformedFilledButton.tertiary(
                context: context,
                text: context.l10n.subscription_restorePurchase,
                withOutline: true,
                onTap: onRestorePressed,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.s),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InformedFilledButton.tertiary(
              context: context,
              text: context.l10n.settings_termsOfService,
              onTap: () => context.pushRoute(
                SettingsTermsOfServicePageRoute(
                  fromRoute: context.l10n.subscription_button_standard,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppDimens.sl),
            ),
            const SizedBox(width: AppDimens.m),
            InformedFilledButton.tertiary(
              context: context,
              text: context.l10n.settings_privacyPolicy,
              onTap: () => context.pushRoute(
                SettingsPrivacyPolicyPageRoute(
                  fromRoute: context.l10n.subscription_button_standard,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppDimens.sl),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}
