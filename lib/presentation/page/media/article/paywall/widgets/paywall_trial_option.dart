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
          markdown: LocaleKeys.subscription_title_article.tr(),
          baseTextStyle: AppTypography.h1Medium,
        ),
        const SizedBox(height: AppDimens.s),
        Text(
          LocaleKeys.subscription_description.tr(),
          style: AppTypography.b2Medium.copyWith(height: 1.2),
        ),
        const SizedBox(height: AppDimens.m),
        Container(
          padding: const EdgeInsets.all(AppDimens.l),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.m),
            ),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.subscription_planInfo_trial.tr(
                  args: [
                    LocaleKeys.date_daySuffix.tr(args: ['${plan.trialDays}']),
                    plan.priceString,
                  ],
                ),
                style: AppTypography.b2Medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.m),
              SubscribeButton.light(
                plan: plan,
                isLoading: isProcessing,
                onPurchasePressed: onPurchasePressed,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Center(
          child: LinkLabel(
            label: LocaleKeys.subscription_viewAllPlansAction.tr(),
            style: AppTypography.b2Medium,
            onTap: () => AutoRouter.of(context).push(const SubscriptionPageRoute()),
          ),
        ),
      ],
    );
  }
}
