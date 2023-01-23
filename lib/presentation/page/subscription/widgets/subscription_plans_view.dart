part of '../subscription_page.dart';

class SubscriptionPlansView extends HookWidget {
  const SubscriptionPlansView({
    required this.cubit,
    required this.openInBrowser,
    required this.trialViewMode,
    Key? key,
  }) : super(key: key);

  final SubscriptionPageCubit cubit;
  final OpenInBrowserFunction openInBrowser;
  final bool trialViewMode;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);
    final selectedPlanNotifier = useValueNotifier<SubscriptionPlan>(cubit.selectedPlan);

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
                    markdown: LocaleKeys.subscription_title_trial.tr(),
                    baseTextStyle: AppTypography.h1Medium,
                  ),
                ] else ...[
                  InformedMarkdownBody(
                    markdown: LocaleKeys.subscription_title_standard.tr(),
                    baseTextStyle: AppTypography.h1Medium,
                  ),
                  const SizedBox(height: AppDimens.l),
                  const SubscriptionBenefits(),
                ],
                const SizedBox(height: AppDimens.l),
                ...cubit.plans
                    .map(
                      (plan) => ValueListenableBuilder<SubscriptionPlan>(
                        valueListenable: selectedPlanNotifier,
                        builder: (context, value, child) {
                          return SubscriptionPlanCard(
                            plan: plan,
                            isSelected: value == plan,
                            onPlanPressed: (SubscriptionPlan plan) {
                              selectedPlanNotifier.value = plan;
                              cubit.selectPlan(plan);
                            },
                          );
                        },
                      ),
                    )
                    .withDividers(divider: const SizedBox(height: AppDimens.m)),
                const SizedBox(height: AppDimens.xl),
                ValueListenableBuilder<SubscriptionPlan>(
                  valueListenable: selectedPlanNotifier,
                  builder: (context, selectedPlan, child) {
                    return SubscribeButton.dark(
                      plan: selectedPlan,
                      onPurchasePressed: (_) => cubit.purchase(),
                      isLoading: state.maybeMap(
                        processing: (_) => true,
                        orElse: () => false,
                      ),
                    );
                  },
                ),
                if (defaultTargetPlatform.isApple) ...[
                  const SizedBox(height: AppDimens.m),
                  LinkLabel(
                    label: LocaleKeys.subscription_redeemCode.tr(),
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
            child: ValueListenableBuilder<SubscriptionPlan>(
              valueListenable: selectedPlanNotifier,
              builder: (context, value, child) {
                return SubscriptionLinksFooter(
                  subscriptionPlan: value,
                  onRestorePressed: cubit.restorePurchase,
                  openInBrowser: openInBrowser,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
