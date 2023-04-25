import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

class SubscriptionFooterButtons extends StatelessWidget {
  const SubscriptionFooterButtons({
    required this.onRestorePressed,
    required this.onRedeemCode,
  });

  final VoidCallback onRestorePressed;
  final VoidCallback onRedeemCode;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (isIOS) ...[
              Expanded(
                child: InformedFilledButton.tertiary(
                  context: context,
                  text: context.l10n.subscription_redeemCode,
                  withOutline: true,
                  onTap: onRedeemCode,
                ),
              ),
              const SizedBox(width: AppDimens.s),
            ],
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
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: InformedFilledButton.tertiary(
                  context: context,
                  text: context.l10n.settings_termsOfService,
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.sl),
                  onTap: () => context.pushRoute(
                    SettingsTermsOfServicePageRoute(
                      fromRoute: context.l10n.subscription_button_standard,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.l),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: InformedFilledButton.tertiary(
                  context: context,
                  text: context.l10n.settings_privacyPolicy,
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.sl),
                  onTap: () => context.pushRoute(
                    SettingsPrivacyPolicyPageRoute(
                      fromRoute: context.l10n.subscription_button_standard,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}
