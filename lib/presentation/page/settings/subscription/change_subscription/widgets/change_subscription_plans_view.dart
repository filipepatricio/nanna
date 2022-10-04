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
    final state = useCubitBuilder(cubit);

    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              const SizedBox(height: AppDimens.m),
              InformedMarkdownBody(
                markdown: LocaleKeys.subscription_change_title.tr(),
                baseTextStyle: AppTypography.h1MediumLora,
              ),
              const SizedBox(height: AppDimens.xl),
              state.maybeMap(
                idle: (data) => _PlanCardsList(
                  plans: data.plans,
                  selectedPlanNotifier: selectedPlanNotifier,
                  currentPlan: currentPlan,
                  cubit: cubit,
                ),
                processing: (data) => _PlanCardsList(
                  plans: data.plans,
                  selectedPlanNotifier: selectedPlanNotifier,
                  currentPlan: currentPlan,
                  cubit: cubit,
                ),
                orElse: () => Container(),
              ),
              const SizedBox(height: AppDimens.xl),
              ValueListenableBuilder<SubscriptionPlan>(
                valueListenable: selectedPlanNotifier,
                builder: (context, selectedPlan, _) {
                  return FilledButton(
                    text: LocaleKeys.subscription_change_confirm.tr(),
                    onTap: cubit.purchase,
                    fillColor: AppColors.charcoal,
                    textColor: AppColors.white,
                    disableColor: AppColors.lightGrey,
                    disableTextColor: AppColors.darkGrey,
                    isEnabled: currentPlan?.productId != selectedPlan.productId,
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
        SliverFillRemaining(
          hasScrollBody: false,
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
      ],
    );
  }
}

class _PlanCardsList extends StatelessWidget {
  const _PlanCardsList({
    required this.plans,
    required this.selectedPlanNotifier,
    required this.currentPlan,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final List<SubscriptionPlan> plans;
  final ValueNotifier<SubscriptionPlan> selectedPlanNotifier;
  final SubscriptionPlan? currentPlan;
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
                  isSelected: plan.productId == selectedPlan.productId,
                  isCurrent: plan.productId == currentPlan?.productId,
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
