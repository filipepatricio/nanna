part of '../subscription_page.dart';

class _SubscriptionPlansView extends HookWidget {
  const _SubscriptionPlansView({
    required this.cubit,
    required this.openInBrowser,
    Key? key,
  }) : super(key: key);

  final SubscriptionPageCubit cubit;
  final OpenInBrowserFunction openInBrowser;

  @override
  Widget build(BuildContext context) {
    final selectedPlanNotifier = useValueNotifier<SubscriptionPlan>(cubit.selectedPlan);

    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              const SizedBox(height: AppDimens.l),
              InformedMarkdownBody(
                markdown: LocaleKeys.subscription_yourFreeTrial.tr(),
                baseTextStyle: AppTypography.h1MediumLora,
              ),
              const SizedBox(height: AppDimens.l),
              ...cubit.plans
                  .map(
                    (plan) => SubscriptionPlanCard(
                      plan: plan,
                      selectedPlanNotifier: selectedPlanNotifier,
                      onTap: () => cubit.selectPlan(plan),
                    ),
                  )
                  .withDividers(divider: const SizedBox(height: AppDimens.m))
                  .toList(),
              const SizedBox(height: AppDimens.xl),
              SubscribeButton(cubit: cubit),
              const SizedBox(height: AppDimens.m),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: _LinksFooter(
            cubit: cubit,
            selectedPlanNotifier: selectedPlanNotifier,
            openInBrowser: openInBrowser,
          ),
        ),
      ],
    );
  }
}
