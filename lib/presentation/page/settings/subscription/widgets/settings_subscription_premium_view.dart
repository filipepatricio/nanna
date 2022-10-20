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
            Text(
              LocaleKeys.subscription_membership.tr(),
              style: AppTypography.h4Bold,
            ),
            const SizedBox(height: AppDimens.l),
            _ChangeSubscriptionCard(
              icon: AppVectorGraphics.informedLogoGreen,
              title: LocaleKeys.subscription_premium.tr(),
              subtitle: subscription.plan.title,
              onTap: () => context.pushRoute(const ChangeSubscriptionPageRoute()),
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              LocaleKeys.subscription_planIncludes.tr(),
              style: AppTypography.subH1Medium.copyWith(color: AppColors.settingsHeader),
            ),
            const SizedBox(height: AppDimens.ml),
            const SubscriptionBenefits(),
            const SizedBox(height: AppDimens.xl),
            if (subscription.expirationDate != null) ...[
              Text(
                (subscription.willRenew ? LocaleKeys.subscription_renewalDate : LocaleKeys.subscription_endDate).tr(),
                style: AppTypography.subH1Medium.copyWith(color: AppColors.settingsHeader),
              ),
              const SizedBox(height: AppDimens.ml),
              Text(
                DateFormatUtil.formatFullMonthNameDayYear(subscription.expirationDate!),
                style: AppTypography.subH1Medium,
              ),
            ],
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
