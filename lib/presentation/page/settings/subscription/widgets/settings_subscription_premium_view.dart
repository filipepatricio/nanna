part of '../settings_subscription_page.dart';

class _SettingsSubscriptionPremiumView extends StatelessWidget {
  const _SettingsSubscriptionPremiumView({
    required this.subscription,
    required this.onManageSubscriptionPressed,
    Key? key,
  }) : super(key: key);

  final ActiveSubscriptionPremium subscription;
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
              title: context.l10n.subscription_premium,
              subtitle: subscription.plan.title,
              onTap: () => context.pushRoute(const ChangeSubscriptionPageRoute()),
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              context.l10n.subscription_planIncludes,
              style: AppTypography.subH1Medium.copyWith(
                color: AppColors.of(context).textTertiary,
              ),
            ),
            const SizedBox(height: AppDimens.ml),
            const SubscriptionBenefits(),
            if (subscription.expirationDate != null) ...[
              const SizedBox(height: AppDimens.xl),
              Text(
                subscription.willRenew ? context.l10n.subscription_renewalDate : context.l10n.subscription_endDate,
                style: AppTypography.subH1Medium.copyWith(
                  color: AppColors.of(context).textTertiary,
                  height: 2.1,
                ),
              ),
              const SizedBox(height: AppDimens.xs),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
                child: Text(
                  DateFormatUtil.formatFullMonthNameDayYear(subscription.expirationDate!),
                  style: AppTypography.subH1Medium,
                ),
              ),
            ],
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
