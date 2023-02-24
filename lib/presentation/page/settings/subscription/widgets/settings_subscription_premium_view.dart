part of '../settings_subscription_page.dart';

class _SettingsSubscriptionPremiumView extends StatelessWidget {
  const _SettingsSubscriptionPremiumView({
    required this.subscription,
    required this.onCancelSubscriptionTap,
    Key? key,
  }) : super(key: key);

  final ActiveSubscriptionPremium subscription;
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
            const SizedBox(height: AppDimens.xl),
            if (subscription.expirationDate != null) ...[
              Text(
                subscription.willRenew ? context.l10n.subscription_renewalDate : context.l10n.subscription_endDate,
                style: AppTypography.subH1Medium.copyWith(
                  color: AppColors.of(context).textTertiary,
                ),
              ),
              const SizedBox(height: AppDimens.ml),
              Text(
                DateFormatUtil.formatFullMonthNameDayYear(subscription.expirationDate!),
                style: AppTypography.subH1Medium,
              ),
            ],
            const SizedBox(height: AppDimens.xxl),
            if (subscription.manageSubscriptionURL.isNotEmpty) ...[
              LinkLabel(
                label: context.l10n.subscription_cancelSubscription,
                style: AppTypography.buttonBold,
                align: TextAlign.start,
                onTap: onCancelSubscriptionTap,
              ),
              const SizedBox(height: AppDimens.l),
            ],
            const AudioPlayerBannerPlaceholder(),
          ],
        ),
      ),
    );
  }
}
