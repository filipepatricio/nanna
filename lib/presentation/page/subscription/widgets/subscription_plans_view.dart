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
    final scrollController = PrimaryScrollController.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BottomListFadeView(
            scrollController: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              physics: getPlatformScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        const SizedBox(height: AppDimens.l),
                        Text(
                          context.l10n.subscription_title_standard,
                          style: AppTypography.sansTitleLargeLausanne,
                        ),
                        if (!trialViewMode) ...[
                          const SizedBox(height: AppDimens.m),
                          Text(
                            context.l10n.subscription_subtitle_noTrial,
                            style: AppTypography.sansTextSmallLausanne,
                          ),
                        ],
                        const SizedBox(height: AppDimens.l),
                        const SubscriptionBenefits(),
                        const SizedBox(height: AppDimens.xl),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppDimens.s,
                    mainAxisSpacing: AppDimens.s,
                    childAspectRatio: 1.4,
                    children: [
                      ...planGroup.plans.map(
                        (plan) => SubscriptionPlanCell(
                          plan: plan,
                          isSelected: selectedPlan == plan,
                          highestMonthlyCostPlan: planGroup.highestMonthlyCostPlan,
                          onPlanPressed: (SubscriptionPlan plan) {
                            cubit.selectPlan(plan);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        const SizedBox(height: AppDimens.l),
                        if (trialViewMode) ...[
                          TrialTimeline(plan: selectedPlan),
                          const SizedBox(height: AppDimens.l),
                          const SubscriptionCancelInfoCard(),
                        ],
                        const SizedBox(height: AppDimens.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SubscribeButton.dark(
                plan: selectedPlan,
                onPurchasePressed: (_) => cubit.purchase(),
                isLoading: state.maybeMap(
                  processing: (_) => true,
                  orElse: () => false,
                ),
              ),
              const SizedBox(height: AppDimens.l),
              SubscriptionLinksFooter(
                subscriptionPlan: selectedPlan,
                onRestorePressed: cubit.restorePurchase,
                onRedeemCode: cubit.redeemOfferCode,
                openInBrowser: openInBrowser,
              ),
            ],
          ),
        )
      ],
    );
  }
}
