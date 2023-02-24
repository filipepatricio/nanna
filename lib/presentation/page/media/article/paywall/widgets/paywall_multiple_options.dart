part of '../article_paywall_view.dart';

class _PaywallMultipleOptions extends HookWidget {
  const _PaywallMultipleOptions({
    required this.planGroup,
    required this.onPurchasePressed,
    required this.onRestorePressed,
    required this.isProcessing,
    required this.onRedeemCodePressed,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlanGroup planGroup;
  final OnPurchasePressed onPurchasePressed;
  final VoidCallback onRestorePressed;
  final VoidCallback onRedeemCodePressed;

  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState(planGroup.plans.first);
    final snackbarController = useSnackbarController();

    Future<void> openInBrowser(String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(context, uri, snackbarController);
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InformedMarkdownBody(
          markdown: context.l10n.subscription_title_article,
          baseTextStyle: AppTypography.h1Medium,
        ),
        const SizedBox(height: AppDimens.l),
        ...planGroup.plans
            .map(
              (plan) => SubscriptionPlanCard(
                plan: plan,
                isSelected: selectedPlan.value == plan,
                highestMonthlyCostPlan: planGroup.highestMonthlyCostPlan,
                onPlanPressed: (plan) {
                  selectedPlan.value = plan;
                },
              ),
            )
            .withDividers(divider: const SizedBox(height: AppDimens.m)),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
          child: SubscribeButton.light(
            plan: selectedPlan.value,
            isLoading: isProcessing,
            onPurchasePressed: onPurchasePressed,
            contentType: SubscriptionButtonContentType.lite,
          ),
        ),
        if (defaultTargetPlatform.isApple) ...[
          const SizedBox(height: AppDimens.m),
          LinkLabel(
            label: context.l10n.subscription_redeemCode,
            onTap: onRedeemCodePressed,
          ),
        ],
        const SizedBox(height: AppDimens.l),
        SubscriptionLinksFooter(
          subscriptionPlan: selectedPlan.value,
          onRestorePressed: onRestorePressed,
          openInBrowser: openInBrowser,
        ),
      ],
    );
  }
}
