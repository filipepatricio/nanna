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
              title: context.l10n.subscription_premium,
              subtitle: null,
              onTap: () => context.pushRoute(const SubscriptionPageRoute()),
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
                context.l10n.subscription_endDate,
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
