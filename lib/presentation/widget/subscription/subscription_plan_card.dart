import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'timeline.dart';

typedef OnPlanPressed = void Function(SubscriptionPlan plan);

class SubscriptionPlanCard extends HookWidget {
  const SubscriptionPlanCard({
    required this.plan,
    required this.highestMonthlyCostPlan,
    required this.isSelected,
    required this.onPlanPressed,
    this.isCurrent = false,
    this.isNextPlan = false,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan plan;
  final SubscriptionPlan highestMonthlyCostPlan;
  final bool isSelected;
  final OnPlanPressed onPlanPressed;
  final bool isCurrent;
  final bool isNextPlan;

  @override
  Widget build(BuildContext context) {
    const animationsDuration = Duration(milliseconds: 250);

    final eventController = useEventTrackingController();

    return GeneralEventTracker(
      controller: eventController,
      child: GestureDetector(
        onTap: () {
          eventController.track(AnalyticsEvent.subscriptionPlanSelected(packageId: plan.packageId));
          onPlanPressed(plan);
        },
        child: Stack(
          children: [
            AnimatedContainer(
              duration: animationsDuration,
              padding: const EdgeInsets.all(AppDimens.m),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.of(context).borderTertiary : AppColors.of(context).borderPrimary,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.modalRadius),
                ),
                color:
                    isSelected ? AppColors.of(context).blackWhiteSecondary : AppColors.of(context).backgroundSecondary,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isCurrent) ...[
                    Text(
                      context.l10n.subscription_change_currentPlan,
                      style: AppTypography.b2Regular.copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.xs),
                  ] else if (isNextPlan) ...[
                    Text(
                      context.l10n.subscription_change_upcomingPlan,
                      style: AppTypography.b2Regular.copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.xs),
                  ],
                  Flexible(
                    child: AutoSizeText(
                      plan.title,
                      style: AppTypography.sansTitleSmallLausanne.w550,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xs),
                  if (plan.hasTrial) ...[
                    Text(
                      plan.description,
                      style: AppTypography.b2Regular.copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.s),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        plan.priceString,
                        style: AppTypography.b2Medium,
                      ),
                      if (plan.monthlyPrice < highestMonthlyCostPlan.monthlyPrice) ...[
                        const SizedBox(width: AppDimens.s),
                        Text(
                          context.l10n.subscription_monthlyPriceComparison(
                            plan.monthlyPriceString,
                            highestMonthlyCostPlan.monthlyPriceString,
                          ),
                          style: AppTypography.sansTextNanoLausanne.copyWith(
                            color: AppColors.of(context).textSecondary,
                          ),
                        ),
                      ]
                    ],
                  ),
                  if (plan.hasTrial)
                    AnimatedOpacity(
                      opacity: isSelected ? 1 : 0,
                      duration: animationsDuration,
                      child: AnimatedSize(
                        duration: animationsDuration,
                        curve: Curves.linearToEaseOut,
                        child: isSelected
                            ? Padding(
                                padding: const EdgeInsets.only(top: AppDimens.l),
                                child: _Timeline(plan: plan),
                              )
                            : Container(),
                      ),
                    ),
                ],
              ),
            ),
            if (plan.discountPercentage > 0)
              Positioned(
                top: AppDimens.m,
                right: AppDimens.m,
                child: _DiscountBadge(plan: plan),
              ),
          ],
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.plan});

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.s,
        horizontal: AppDimens.sl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.pillRadius),
        color: AppColors.of(context).buttonAccentBackground,
      ),
      child: Text(
        context.l10n.subscription_off('${plan.discountPercentage}'),
        style: AppTypography.sansTextSmallLausanne.copyWith(
          color: AppColors.of(context).buttonAccentText,
          height: 1,
        ),
      ),
    );
  }
}
