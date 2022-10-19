part of '../settings_subscription_page.dart';

class _SettingsSubscriptionTrialView extends StatelessWidget {
  const _SettingsSubscriptionTrialView({
    required this.subscription,
    required this.onCancelSubscriptionTap,
    Key? key,
  }) : super(key: key);

  final ActiveSubscriptionTrial subscription;
  final VoidCallback onCancelSubscriptionTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        child: ListView(
          physics: getPlatformScrollPhysics(),
          children: [
            const SizedBox(height: AppDimens.l),
            Text(
              LocaleKeys.subscription_membership.tr(),
              style: AppTypography.h4Bold,
            ),
            const SizedBox(height: AppDimens.l),
            _ChangeSubscriptionCard(
              icon: AppVectorGraphics.informedLogoGreen,
              title: LocaleKeys.subscription_trial.tr(),
              subtitle: subscription.plan.title,
              onTap: () => context.pushRoute(const ChangeSubscriptionPageRoute()),
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              LocaleKeys.subscription_settings_endsIn.tr(args: ['${subscription.remainingTrialDays}']),
              style: AppTypography.subH1Medium,
            ),
            const SizedBox(height: AppDimens.l),
            Text(
              LocaleKeys.subscription_settings_freeThrough.tr(
                args: [
                  DateFormatUtil.formatFullMonthNameDayYear(
                    clock.now().add(Duration(days: subscription.remainingTrialDays)),
                  ),
                  subscription.plan.priceString,
                  subscription.plan.type.period,
                ],
              ),
              style: AppTypography.metadata1Medium.copyWith(color: AppColors.textGrey),
            ),
            const SizedBox(height: AppDimens.l),
            const InformedDivider(),
            const SizedBox(height: AppDimens.l),
            if (subscription.manageSubscriptionURL.isNotEmpty)
              LinkLabel(
                label: LocaleKeys.subscription_cancelSubscription.tr(),
                style: AppTypography.buttonBold,
                align: TextAlign.start,
                onTap: onCancelSubscriptionTap,
              ),
          ],
        ),
      ),
    );
  }
}

extension on SubscriptionPlanType {
  String get period {
    switch (this) {
      case SubscriptionPlanType.annual:
        return LocaleKeys.date_year.tr();
      case SubscriptionPlanType.monthly:
        return LocaleKeys.date_month.tr();
    }
  }
}
