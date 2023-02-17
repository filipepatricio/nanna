part of 'subscription_plan_card.dart';

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.plan,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    const timelineColumnWidth = 29.0;
    const dottedTimelineWidth = 1.0;
    const dotSize = 13.0;

    final labelStyle = AppTypography.subH1Regular.copyWith(
      height: 1.4,
      color: AppColors.of(context).textSecondary,
    );

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              top: dotSize * .5,
              bottom: dotSize,
              left: (dotSize - dottedTimelineWidth) * .5,
              child: DottedLine(
                direction: Axis.vertical,
                lineLength: double.infinity,
                lineThickness: dottedTimelineWidth,
                dashLength: dottedTimelineWidth,
                dashColor: AppColors.of(context).borderSecondary,
                dashRadius: dottedTimelineWidth,
                dashGapLength: AppDimens.xs,
                dashGapColor: AppColors.of(context).backgroundPrimary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const _TimelineColumnCell(
                      width: timelineColumnWidth,
                      child: Icon(
                        Icons.circle,
                        size: dotSize,
                        color: AppColors.brandAccent,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        context.l10n.subscription_startYourTrial,
                        style: labelStyle,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.ml),
                Row(
                  children: [
                    const _TimelineColumnCell(
                      width: timelineColumnWidth,
                      child: _OutlinedDot(size: dotSize),
                    ),
                    Flexible(
                      child: Text(
                        context.l10n.subscription_receiveAnEmail(
                          context.l10n.date_day(plan.reminderDays),
                        ),
                        style: labelStyle,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.ml),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _TimelineColumnCell(
                      width: timelineColumnWidth,
                      child: _OutlinedDot(size: dotSize),
                    ),
                    Flexible(
                      child: Text(
                        context.l10n.subscription_youllBeCharged(
                          context.l10n.date_day(plan.trialDays),
                          plan.priceString,
                          plan.type.text(context),
                        ),
                        style: labelStyle,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineColumnCell extends StatelessWidget {
  const _TimelineColumnCell({
    required this.width,
    required this.child,
    Key? key,
  }) : super(key: key);

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.topLeft,
      child: child,
    );
  }
}

class _OutlinedDot extends StatelessWidget {
  const _OutlinedDot({
    required this.size,
    Key? key,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size * .125),
      child: Container(
        height: size * .75,
        width: size * .75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.of(context).blackWhiteSecondary,
          border: Border.all(
            width: 1,
            color: AppColors.of(context).borderSecondary,
          ),
        ),
      ),
    );
  }
}

extension on SubscriptionPlanType {
  String text(BuildContext context) {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return context.l10n.subscription_subscriptionTypeName_monthly;
      case SubscriptionPlanType.annual:
        return context.l10n.subscription_subscriptionTypeName_annual;
    }
  }
}
