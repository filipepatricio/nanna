import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnPlanPressed = void Function(SubscriptionPlan plan);

class SubscriptionPlanCell extends HookWidget {
  const SubscriptionPlanCell({
    required this.plan,
    required this.highestMonthlyCostPlan,
    required this.isSelected,
    required this.onPlanPressed,
    super.key,
  });

  final SubscriptionPlan plan;
  final SubscriptionPlan highestMonthlyCostPlan;
  final bool isSelected;
  final OnPlanPressed onPlanPressed;

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackingController();

    return GestureDetector(
      onTap: () {
        eventController.track(AnalyticsEvent.subscriptionPlanSelected(packageId: plan.packageId));
        onPlanPressed(plan);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimens.s),
        decoration: BoxDecoration(
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.of(context).borderPrimary,
                ),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          color: isSelected
              ? AppColors.of(context).buttonAccentBackground
              : AppColors.of(context).buttonAccentBackground.withOpacity(0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _SaveBadge(plan.discountPercentage),
            const Spacer(),
            _Price(plan: plan, highestMonthlyCostPlan: highestMonthlyCostPlan),
            const Spacer(),
            _TrialInfo(plan),
          ],
        ),
      ),
    );
  }
}

class _SaveBadge extends StatelessWidget {
  const _SaveBadge(this.discountPercentage);

  final int discountPercentage;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: discountPercentage > 0 ? 1 : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.s, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color: AppColors.brandPrimary,
          borderRadius: BorderRadius.circular(AppDimens.defaultRadius),
        ),
        child: Text(
          context.l10n.subscription_off('$discountPercentage'),
          style: AppTypography.sansTextNanoLausanne.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({
    required this.plan,
    required this.highestMonthlyCostPlan,
  });

  final SubscriptionPlan plan;
  final SubscriptionPlan highestMonthlyCostPlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.subscription_card_price(plan.priceString, plan.periodString(context)),
          style: AppTypography.sansTextDefaultLausanneBold,
          textAlign: TextAlign.center,
        ),
        if (plan.monthlyPrice < highestMonthlyCostPlan.monthlyPrice) ...[
          Text(
            context.l10n.subscription_card_monthlyPrice(plan.monthlyPriceString, context.l10n.date_month),
            style: AppTypography.sansTextNanoLausanne.copyWith(
              color: AppColors.of(context).textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _TrialInfo extends StatelessWidget {
  const _TrialInfo(this.plan);

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: plan.trialDays > 0 ? 1 : 0,
      child: Text(
        context.l10n.subscription_card_trialDays(plan.trialDays),
        style: AppTypography.sansTextNanoLausanne.copyWith(
          color: AppColors.of(context).textSecondary,
        ),
      ),
    );
  }
}

extension on SubscriptionPlan {
  String periodString(BuildContext context) => isAnnual ? context.l10n.date_year : context.l10n.date_month;
}
