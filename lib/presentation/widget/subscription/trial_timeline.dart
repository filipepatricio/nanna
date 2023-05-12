import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class TrialTimeline extends StatelessWidget {
  const TrialTimeline({
    required this.plan,
    super.key,
  });

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    final trialEndDate = DateTime.now().add(Duration(days: plan.trialDays));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.subscription_trialTimeline_title(plan.trialDays),
          style: AppTypography.sansTextSmallLausanneBold,
        ),
        const SizedBox(height: AppDimens.l),
        _TimelineStep(
          icon: AppVectorGraphics.locker,
          title: context.l10n.subscription_trialTimeline_step1_title,
          description: context.l10n.subscription_trialTimeline_step1_description,
        ),
        const SizedBox(height: AppDimens.m),
        _TimelineStep(
          icon: AppVectorGraphics.alert,
          title: context.l10n.subscription_trialTimeline_step2_title(plan.reminderDays),
          description: context.l10n.subscription_trialTimeline_step2_description,
        ),
        const SizedBox(height: AppDimens.m),
        _TimelineStep(
          icon: AppVectorGraphics.star,
          title: context.l10n.subscription_trialTimeline_step3_title(plan.trialDays),
          description: context.l10n.subscription_trialTimeline_step3_description(
            plan.priceString,
            DateFormat.MMMMd().format(trialEndDate),
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final String icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InformedSvg(icon),
        const SizedBox(width: AppDimens.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.sansTextSmallLausanneBold,
              ),
              const SizedBox(height: AppDimens.xs),
              Text(
                description,
                style: AppTypography.sansTextSmallLausanne.copyWith(color: AppColors.of(context).textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
