part of 'subscription_plans_view.dart';

class _SubscriptionFooterButtons extends StatelessWidget {
  const _SubscriptionFooterButtons({
    required this.subscriptionPlan,
    required this.onRestorePressed,
    required this.onRedeemCode,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan subscriptionPlan;
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
