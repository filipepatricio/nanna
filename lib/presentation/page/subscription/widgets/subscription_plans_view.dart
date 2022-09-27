part of '../subscription_page.dart';

class _SubscriptionPlansView extends HookWidget {
  const _SubscriptionPlansView({
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
    final selectedPlanNotifier = useValueNotifier<SubscriptionPlan>(cubit.selectedPlan);
    final state = useCubitBuilder(cubit);

    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              const SizedBox(height: AppDimens.l),
              if (trialViewMode) ...[
                InformedMarkdownBody(
                  markdown: LocaleKeys.subscription_title_trial.tr(),
                  baseTextStyle: AppTypography.h1MediumLora,
                ),
              ] else ...[
                InformedMarkdownBody(
                  markdown: LocaleKeys.subscription_title_standard.tr(),
                  baseTextStyle: AppTypography.h1MediumLora,
                ),
                const SizedBox(height: AppDimens.l),
                ...[
                  _SubscriptionInfoLine(text: LocaleKeys.subscription_info_access.tr()),
                  _SubscriptionInfoLine(text: LocaleKeys.subscription_info_reporting.tr()),
                  _SubscriptionInfoLine(text: LocaleKeys.subscription_info_fresh.tr()),
                ].withDividers(
                  divider: const SizedBox(height: AppDimens.m),
                ),
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
                builder: (context, value, child) {
                  return SubscribeButton(
                    plan: value,
                    onPurchasePressed: (_) => cubit.purchase(),
                    isLoading: state.maybeMap(
                      processing: (_) => true,
                      orElse: () => false,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimens.m),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
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
      ],
    );
  }
}

class _SubscriptionInfoLine extends StatelessWidget {
  const _SubscriptionInfoLine({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AppVectorGraphics.checkmark),
        const SizedBox(width: AppDimens.s),
        Text(
          text,
          style: AppTypography.subH1Medium,
        ),
      ],
    );
  }
}
