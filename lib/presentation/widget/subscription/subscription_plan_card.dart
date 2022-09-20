import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'timeline.dart';

typedef OnPlanPressed = void Function(SubscriptionPlan plan);

class SubscriptionPlanCard extends HookWidget {
  const SubscriptionPlanCard({
    required this.plan,
    required this.isSelected,
    required this.onPlanPressed,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan plan;
  final bool isSelected;
  final OnPlanPressed onPlanPressed;

  @override
  Widget build(BuildContext context) {
    const animationsDuration = Duration(milliseconds: 200);

    final eventController = useEventTrackingController();

    return GeneralEventTracker(
      controller: eventController,
      child: GestureDetector(
        onTap: () {
          eventController.track(AnalyticsEvent.subscriptionPlanSelected(packageId: plan.packageId));
          onPlanPressed(plan);
        },
        child: AnimatedContainer(
          duration: animationsDuration,
          padding: const EdgeInsets.all(AppDimens.m),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? AppColors.charcoal : AppColors.lightGrey),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.ml),
            ),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: AutoSizeText(
                  plan.title,
                  style: AppTypography.h4ExtraBold.copyWith(height: 1),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: AppDimens.xs),
              if (plan.hasTrial) ...[
                Text(
                  plan.description,
                  style: AppTypography.b1Medium.copyWith(color: AppColors.darkerGrey),
                ),
                const SizedBox(height: AppDimens.xs),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.priceString,
                    style: AppTypography.h4ExtraBold,
                  ),
                  if (plan.discountPercentage > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.xs,
                        horizontal: AppDimens.s,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.pastelPurple,
                      ),
                      child: Text(
                        LocaleKeys.subscription_off.tr(args: [('${plan.discountPercentage}')]),
                        style: AppTypography.topicOwnerLabelText,
                      ),
                    ),
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
      ),
    );
  }
}
