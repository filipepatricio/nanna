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
      children: [
        InformedMarkdownBody(
          markdown: LocaleKeys.subscription_title_standard.tr(),
          baseTextStyle: AppTypography.h1MediumLora,
        ),
        const SizedBox(height: AppDimens.s),
        Text(
          LocaleKeys.subscription_description.tr(),
          style: AppTypography.subH1Medium,
        ),
        const SizedBox(height: AppDimens.m),
        Container(
          padding: const EdgeInsets.all(AppDimens.l),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.m),
            ),
            border: Border.all(
              color: AppColors.secondaryNeutralGrey,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.subscription_subscriptionInfo_withTrial.tr(
                  args: [
                    '${plan.trialDays} ${LocaleKeys.date_day.plural(plan.trialDays)}',
                    plan.priceString,
                  ],
                ),
                style: AppTypography.h4ExtraBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.m),
              SubscribeButton(
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
