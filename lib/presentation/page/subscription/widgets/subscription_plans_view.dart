part of '../subscription_page.dart';

class SubscriptionPlansView extends HookWidget {
  const SubscriptionPlansView({
    required this.cubit,
    required this.openInBrowser,
    required this.trialViewMode,
    required this.planGroup,
    required this.selectedPlan,
    Key? key,
  }) : super(key: key);

  final SubscriptionPageCubit cubit;
  final OpenInBrowserFunction openInBrowser;
  final bool trialViewMode;
  final SubscriptionPlanGroup planGroup;
  final SubscriptionPlan selectedPlan;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);

    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const SizedBox(height: AppDimens.l),
                if (trialViewMode) ...[
                  InformedMarkdownBody(
                    markdown: context.l10n.subscription_title_trial,
                    baseTextStyle: AppTypography.h1Medium,
                  ),
                ] else ...[
                  InformedMarkdownBody(
                    markdown: context.l10n.subscription_title_standard,
                    baseTextStyle: AppTypography.h1Medium,
                  ),
                  const SizedBox(height: AppDimens.l),
                  const SubscriptionBenefits(),
                ],
                const SizedBox(height: AppDimens.l),
                ...planGroup.plans
                    .map(
                      (plan) => SubscriptionPlanCard(
                        plan: plan,
                        isSelected: selectedPlan == plan,
                        highestMonthlyCostPlan: planGroup.highestMonthlyCostPlan,
                        onPlanPressed: (SubscriptionPlan plan) {
                          cubit.selectPlan(plan);
                        },
                      ),
                    )
                    .withDividers(divider: const SizedBox(height: AppDimens.m)),
                const SizedBox(height: AppDimens.xl),
                SubscribeButton.dark(
                  plan: selectedPlan,
                  onPurchasePressed: (_) => cubit.purchase(),
                  isLoading: state.maybeMap(
                    processing: (_) => true,
                    orElse: () => false,
                  ),
                ),
                if (defaultTargetPlatform.isApple) ...[
                  const SizedBox(height: AppDimens.m),
                  LinkLabel(
                    label: context.l10n.subscription_redeemCode,
                    onTap: cubit.redeemOfferCode,
                  ),
                ],
                const SizedBox(height: AppDimens.m),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: SubscriptionLinksFooter(
              subscriptionPlan: selectedPlan,
              onRestorePressed: cubit.restorePurchase,
              openInBrowser: openInBrowser,
            ),
          ),
        ),
      ],
    );
  }
}
