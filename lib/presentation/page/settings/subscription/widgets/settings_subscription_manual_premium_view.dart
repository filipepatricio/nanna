part of '../settings_subscription_page.dart';

class _SettingsSubscriptionManualPremiumView extends StatelessWidget {
  const _SettingsSubscriptionManualPremiumView({
    required this.subscription,
    Key? key,
  }) : super(key: key);

  final ActiveSubscriptionManualPremium subscription;

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
              title: LocaleKeys.subscription_premium.tr(),
              subtitle: null,
              onTap: () => context.pushRoute(const SubscriptionPageRoute()),
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              LocaleKeys.subscription_planIncludes.tr(),
              style: AppTypography.subH1Medium.copyWith(
                color: AppColors.of(context).textTertiary,
              ),
            ),
            const SizedBox(height: AppDimens.ml),
            const SubscriptionBenefits(),
            const SizedBox(height: AppDimens.xl),
            if (subscription.expirationDate != null) ...[
              Text(
                LocaleKeys.subscription_endDate.tr(),
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
            const SizedBox(height: AppDimens.l),
            const AudioPlayerBannerPlaceholder(),
          ],
        ),
      ),
    );
  }
}
