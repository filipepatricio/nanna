import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_benefits.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_list_fade_view.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_cell.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/trial_timeline.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'subscription_cancel_info_card.dart';
part 'subscription_footer_buttons.dart';

class SubscriptionPlansView extends HookWidget {
  const SubscriptionPlansView({
    required this.cubit,
    required this.openInBrowser,
    required this.trialViewMode,
    required this.planGroup,
    required this.selectedPlan,
    this.isArticlePaywall = false,
    Key? key,
  }) : super(key: key);

  final SubscriptionPageCubit cubit;
  final OpenInBrowserFunction openInBrowser;
  final bool trialViewMode;
  final SubscriptionPlanGroup planGroup;
  final SubscriptionPlan selectedPlan;
  final bool isArticlePaywall;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);
    final scrollController = PrimaryScrollController.of(context);
    final currentPlan = cubit.currentPlan;
    final hasCurrentPlan = currentPlan != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: BottomListFadeView(
            scrollController: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              shrinkWrap: isArticlePaywall,
              physics: !isArticlePaywall ? getPlatformScrollPhysics() : const NeverScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        const SizedBox(height: AppDimens.m),
                        Text(
                          hasCurrentPlan
                              ? context.l10n.subscription_change_title
                              : context.l10n.subscription_title_standard,
                          style: AppTypography.sansTitleLargeLausanne,
                        ),
                        if (!trialViewMode) ...[
                          const SizedBox(height: AppDimens.m),
                          Text(
                            hasCurrentPlan
                                ? context.l10n.subscription_change_subtitle(
                                    currentPlan.isAnnual
                                        ? context.l10n.subscription_change_annual
                                        : context.l10n.subscription_change_monthly,
                                    currentPlan.isAnnual
                                        ? context.l10n.subscription_change_monthly
                                        : context.l10n.subscription_change_annual,
                                  )
                                : context.l10n.subscription_subtitle_noTrial,
                            style: AppTypography.sansTextSmallLausanne,
                          ),
                        ],
                        if (!hasCurrentPlan) ...[
                          const SizedBox(height: AppDimens.l),
                          const SubscriptionBenefits(),
                        ],
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
                          if (!isArticlePaywall) ...[
                            const SizedBox(height: AppDimens.l),
                            const _SubscriptionCancelInfoCard(),
                          ]
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
                currentPlan: currentPlan,
                selectedPlan: selectedPlan,
                onPurchasePressed: (_) => cubit.purchase(),
                isLoading: state.maybeMap(
                  processing: (_) => true,
                  orElse: () => false,
                ),
              ),
              const SizedBox(height: AppDimens.l),
              if (hasCurrentPlan) ...[
                state.maybeMap(
                  idle: (data) => _ExpirationDateFooter(data.subscription.expirationDate),
                  processing: (data) => _ExpirationDateFooter(data.subscription.expirationDate),
                  orElse: Container.new,
                ),
                const SizedBox(height: AppDimens.l),
              ],
              _SubscriptionFooterButtons(
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
