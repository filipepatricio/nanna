part of '../article_paywall_view.dart';

class _PaywallMultipleOptions extends HookWidget {
  const _PaywallMultipleOptions({
    required this.plans,
    required this.onPurchasePressed,
    required this.onRestorePressed,
    required this.isProcessing,
    Key? key,
  }) : super(key: key);

  final List<SubscriptionPlan> plans;
  final OnPurchasePressed onPurchasePressed;
  final VoidCallback onRestorePressed;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState(plans.first);
    final snackbarController = useSnackbarController();

    Future<void> openInBrowser(String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(uri, snackbarController);
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InformedMarkdownBody(
          markdown: LocaleKeys.subscription_title_article.tr(),
          baseTextStyle: AppTypography.h1Medium,
        ),
        const SizedBox(height: AppDimens.l),
        ...plans
            .map(
              (plan) => SubscriptionPlanCard(
                plan: plan,
                isSelected: selectedPlan.value == plan,
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
          ),
        ),
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
