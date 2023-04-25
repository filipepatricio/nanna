import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
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
                  onTap: onRedeemCode,
                ),
              ),
              const SizedBox(width: AppDimens.s),
            ],
            Expanded(
              child: InformedFilledButton.tertiary(
                context: context,
                text: context.l10n.subscription_restorePurchase,
                onTap: onRestorePressed,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.ml),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: LinkLabel(
                  label: context.l10n.settings_termsOfService,
                  style: AppTypography.sansTextNanoLausanne,
                  decoration: TextDecoration.none,
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
                child: LinkLabel(
                  label: context.l10n.settings_privacyPolicy,
                  style: AppTypography.sansTextNanoLausanne,
                  decoration: TextDecoration.none,
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
