part of '../subscription_page.dart';

class _LinksFooter extends StatelessWidget {
  const _LinksFooter({
    required this.cubit,
    required this.selectedPlanNotifier,
    required this.openInBrowser,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<SubscriptionPlan> selectedPlanNotifier;
  final SubscriptionPageCubit cubit;
  final OpenInBrowserFunction openInBrowser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<SubscriptionPlan>(
          valueListenable: selectedPlanNotifier,
          builder: (context, selectedPlan, child) => Text(
            LocaleKeys.subscription_youllBeChargedFooter.tr(
              args: [daysString(selectedPlan.trialDays)],
            ),
            textAlign: TextAlign.center,
            style: AppTypography.metadata1Medium.copyWith(color: AppColors.textGrey),
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LinkLabel(
              label: LocaleKeys.subscription_restorePurchase.tr(),
              style: AppTypography.metadata1Medium,
              onTap: cubit.restorePurchase,
            ),
            LinkLabel(
              label: LocaleKeys.settings_termsAndConditions.tr(),
              style: AppTypography.metadata1Medium,
              onTap: () => openInBrowser(termsOfServiceUri),
            ),
            LinkLabel(
              label: LocaleKeys.settings_privacyPolicy.tr(),
              style: AppTypography.metadata1Medium,
              onTap: () => openInBrowser(policyPrivacyUri),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}
