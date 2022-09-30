part of '../article_paywall_view.dart';

class _PaywallMultipleOptions extends HookWidget {
  const _PaywallMultipleOptions({
    required this.plans,
    required this.snackbarController,
    required this.onPurchasePressed,
    required this.onRestorePressed,
    required this.isProcessing,
    Key? key,
  }) : super(key: key);

  final List<SubscriptionPlan> plans;
  final SnackbarController snackbarController;
  final OnPurchasePressed onPurchasePressed;
  final VoidCallback onRestorePressed;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState(plans.first);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InformedMarkdownBody(
          markdown: LocaleKeys.subscription_title_standard.tr(),
          baseTextStyle: AppTypography.h1MediumLora,
        ),
        const SizedBox(height: AppDimens.l),
        ...plans
            .map(
              (plan) => SubscriptionPlanCard(
                plan: plan,
                isSelected: selectedPlan.value == plan,
                onPlanPressed: (SubscriptionPlan plan) {
                  selectedPlan.value = plan;
                },
              ),
            )
            .withDividers(divider: const SizedBox(height: AppDimens.m)),
        const SizedBox(height: AppDimens.l),
        SubscribeButton(
          plan: selectedPlan.value,
          isLoading: isProcessing,
          onPurchasePressed: onPurchasePressed,
        ),
        const SizedBox(height: AppDimens.l),
        SubscriptionLinksFooter(
          subscriptionPlan: selectedPlan.value,
          onRestorePressed: onRestorePressed,
          openInBrowser: _openInBrowser,
        ),
      ],
    );
  }

  Future<void> _openInBrowser(String uri) async {
    await openInAppBrowser(
      uri,
      (error, stacktrace) {
        showBrowserError(uri, snackbarController);
      },
    );
  }
}
