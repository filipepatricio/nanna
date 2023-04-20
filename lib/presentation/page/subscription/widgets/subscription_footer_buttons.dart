part of 'subscription_plans_view.dart';

class _SubscriptionFooterButtons extends StatelessWidget {
  const _SubscriptionFooterButtons({
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
