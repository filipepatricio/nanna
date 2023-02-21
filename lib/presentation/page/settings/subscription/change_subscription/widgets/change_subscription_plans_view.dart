part of '../change_subscription_page.dart';

class _ChangeSubscriptionPlansView extends HookWidget {
  const _ChangeSubscriptionPlansView({
    required this.cubit,
    required this.openInBrowser,
    Key? key,
  }) : super(key: key);

  final ChangeSubscriptionPageCubit cubit;
  final OpenInBrowserFunction openInBrowser;

  @override
  Widget build(BuildContext context) {
    final selectedPlanNotifier = useValueNotifier<SubscriptionPlan>(cubit.selectedPlan!);
    final currentPlan = cubit.currentPlan;
    final nextPlan = cubit.nextPlan;
    final state = useCubitBuilder(cubit);

    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const SizedBox(height: AppDimens.m),
                InformedMarkdownBody(
                  markdown: context.l10n.subscription_change_title,
                  baseTextStyle: AppTypography.h1Medium,
                ),
                const SizedBox(height: AppDimens.xl),
                state.maybeMap(
                  idle: (data) => _PlanCardsList(
                    planGroup: data.planGroup,
                    selectedPlanNotifier: selectedPlanNotifier,
                    currentPlan: currentPlan,
                    nextPlan: nextPlan,
                    cubit: cubit,
                  ),
                  processing: (data) => _PlanCardsList(
                    planGroup: data.planGroup,
                    selectedPlanNotifier: selectedPlanNotifier,
                    currentPlan: currentPlan,
                    nextPlan: nextPlan,
                    cubit: cubit,
                  ),
                  orElse: () => Container(),
                ),
                const SizedBox(height: AppDimens.xl),
                ValueListenableBuilder<SubscriptionPlan>(
                  valueListenable: selectedPlanNotifier,
                  builder: (context, selectedPlan, _) {
                    return InformedFilledButton.primary(
                      context: context,
                      text: context.l10n.subscription_change_confirm,
                      onTap: cubit.purchase,
                      isEnabled: currentPlan?.productId != selectedPlan.productId &&
                          currentPlan?.productId != nextPlan?.productId,
                      isLoading: state.maybeMap(
                        processing: (_) => true,
                        orElse: () => false,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimens.m),
                state.maybeMap(
                  idle: (data) => _ExpirationDateFooter(data.subscription.expirationDate),
                  processing: (data) => _ExpirationDateFooter(data.subscription.expirationDate),
                  orElse: Container.new,
                ),
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
              builder: (context, selectedPlan, _) {
                return SubscriptionLinksFooter(
                  subscriptionPlan: selectedPlan,
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

class _PlanCardsList extends StatelessWidget {
  const _PlanCardsList({
    required this.planGroup,
    required this.selectedPlanNotifier,
    required this.currentPlan,
    required this.nextPlan,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlanGroup planGroup;
  final ValueNotifier<SubscriptionPlan> selectedPlanNotifier;
  final SubscriptionPlan? currentPlan;
  final SubscriptionPlan? nextPlan;
  final ChangeSubscriptionPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: planGroup.plans
          .map(
            (plan) => ValueListenableBuilder<SubscriptionPlan>(
              valueListenable: selectedPlanNotifier,
              builder: (context, selectedPlan, _) {
                return SubscriptionPlanCard(
                  plan: plan,
                  isSelected: plan == selectedPlan,
                  isCurrent: plan == currentPlan,
                  isNextPlan: plan == nextPlan,
                  highestMonthlyCostPlan: planGroup.highestMonthlyCostPlan,
                  onPlanPressed: (plan) {
                    selectedPlanNotifier.value = plan;
                    cubit.selectPlan(plan);
                  },
                );
              },
            ),
          )
          .withDividers(divider: const SizedBox(height: AppDimens.m)),
    );
  }
}

class _ExpirationDateFooter extends StatelessWidget {
  const _ExpirationDateFooter(
    this.expirationDate, [
    Key? key,
  ]) : super(key: key);

  final DateTime expirationDate;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.subscription_change_footer(
        DateFormatUtil.formatShortMonthNameDay(expirationDate),
      ),
      textAlign: TextAlign.center,
      style: AppTypography.metadata1Medium.copyWith(color: AppColors.of(context).textSecondary),
    );
  }
}

extension on ActiveSubscription {
  DateTime get expirationDate => map(
        free: (_) => clock.now(),
        trial: (trial) => clock.now().add(Duration(days: trial.remainingTrialDays)),
        premium: (premium) => premium.expirationDate!,
        manualPremium: (premium) => premium.expirationDate!,
      );
}
