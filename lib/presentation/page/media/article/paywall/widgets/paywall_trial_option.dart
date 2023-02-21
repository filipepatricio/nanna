part of '../article_paywall_view.dart';

class _PaywallTrialOption extends StatelessWidget {
  const _PaywallTrialOption({
    required this.plan,
    required this.onPurchasePressed,
    required this.isProcessing,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan plan;
  final OnPurchasePressed onPurchasePressed;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InformedMarkdownBody(
          markdown: context.l10n.subscription_title_article,
          baseTextStyle: AppTypography.h1Medium,
        ),
        const SizedBox(height: AppDimens.s),
        Text(
          context.l10n.subscription_description,
          style: AppTypography.b2Medium.copyWith(height: 1.2),
        ),
        const SizedBox(height: AppDimens.m),
        Container(
          padding: const EdgeInsets.all(AppDimens.l),
          decoration: BoxDecoration(
            color: AppColors.of(context).blackWhiteSecondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.m),
            ),
            border: Border.all(
              color: AppColors.of(context).borderPrimary,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.subscription_planInfo_trial(
                  context.l10n.date_daySuffix('${plan.trialDays}'),
                  plan.priceString,
                ),
                style: AppTypography.b2Medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.m),
              SubscribeButton.light(
                plan: plan,
                isLoading: isProcessing,
                onPurchasePressed: onPurchasePressed,
                contentType: SubscriptionButtonContentType.lite,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Center(
          child: LinkLabel(
            label: context.l10n.subscription_viewAllPlansAction,
            style: AppTypography.b2Medium,
            onTap: () => AutoRouter.of(context).push(const SubscriptionPageRoute()),
          ),
        ),
        const SizedBox(height: AppDimens.xs),
      ],
    );
  }
}
