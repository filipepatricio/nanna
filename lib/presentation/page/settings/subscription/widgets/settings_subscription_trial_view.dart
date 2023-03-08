part of '../settings_subscription_page.dart';

class _SettingsSubscriptionTrialView extends StatelessWidget {
  const _SettingsSubscriptionTrialView({
    required this.subscription,
    required this.onManageSubscriptionPressed,
    Key? key,
  }) : super(key: key);

  final ActiveSubscriptionTrial subscription;
  final VoidCallback onManageSubscriptionPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        child: ListView(
          physics: getPlatformScrollPhysics(),
          children: [
            const SizedBox(height: AppDimens.l),
            _ChangeSubscriptionCard(
              icon: AppVectorGraphics.informedLogoGreen,
              title: context.l10n.subscription_trial,
              subtitle: subscription.plan.title,
              onTap: () => context.pushRoute(const ChangeSubscriptionPageRoute()),
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              context.l10n.subscription_settings_endsIn('${subscription.remainingTrialDays}'),
              style: AppTypography.subH1Medium,
            ),
            const SizedBox(height: AppDimens.l),
            Text(
              context.l10n.subscription_settings_freeThrough(
                DateFormatUtil.formatFullMonthNameDayYear(
                  clock.now().add(Duration(days: subscription.remainingTrialDays)),
                ),
                subscription.plan.priceString,
              ),
              style: AppTypography.metadata1Medium.copyWith(color: AppColors.of(context).textSecondary),
            ),
            const SizedBox(height: AppDimens.l),
            SubscriptionSectionView(onManageSubscriptionPressed: onManageSubscriptionPressed),
            const SizedBox(height: AppDimens.xxl),
            const AudioPlayerBannerPlaceholder(),
          ],
        ),
      ),
    );
  }
}
