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
                  markdown: LocaleKeys.subscription_change_title.tr(),
                  baseTextStyle: AppTypography.h1Medium,
                ),
                const SizedBox(height: AppDimens.xl),
                state.maybeMap(
                  idle: (data) => _PlanCardsList(
                    plans: data.plans,
                    selectedPlanNotifier: selectedPlanNotifier,
                    currentPlan: currentPlan,
                    nextPlan: nextPlan,
                    cubit: cubit,
                  ),
                  processing: (data) => _PlanCardsList(
                    plans: data.plans,
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
                    return FilledButton.black(
                      text: LocaleKeys.subscription_change_confirm.tr(),
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
    required this.plans,
    required this.selectedPlanNotifier,
    required this.currentPlan,
    required this.nextPlan,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final List<SubscriptionPlan> plans;
  final ValueNotifier<SubscriptionPlan> selectedPlanNotifier;
  final SubscriptionPlan? currentPlan;
  final SubscriptionPlan? nextPlan;
  final ChangeSubscriptionPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: plans
          .map(
            (plan) => ValueListenableBuilder<SubscriptionPlan>(
              valueListenable: selectedPlanNotifier,
              builder: (context, selectedPlan, _) {
                return SubscriptionPlanCard(
                  plan: plan,
                  isSelected: plan == selectedPlan,
                  isCurrent: plan == currentPlan,
                  isNextPlan: plan == nextPlan,
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
      LocaleKeys.subscription_change_footer.tr(
        args: [DateFormatUtil.formatShortMonthNameDay(expirationDate)],
      ),
      textAlign: TextAlign.center,
      style: AppTypography.metadata1Medium.copyWith(color: AppColors.textGrey),
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
