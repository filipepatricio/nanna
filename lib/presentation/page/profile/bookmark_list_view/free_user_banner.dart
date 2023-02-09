part of 'bookmark_list_view.dart';

class FreeUserBanner extends StatelessWidget {
  const FreeUserBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalMargin,
        AppDimens.m,
        AppDimens.pageHorizontalMargin,
        AppDimens.zero,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.l),
        decoration: const BoxDecoration(
          color: AppColors.brandAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.profile_banner_title.tr(),
              textAlign: TextAlign.center,
              style: AppTypography.serifTitleLargeIvar.copyWith(
                color: AppColors.stateTextPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.m),
            Text(
              LocaleKeys.profile_banner_body.tr(),
              textAlign: TextAlign.center,
              style: AppTypography.sansTextSmallLausanne.copyWith(
                color: AppColors.stateTextPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.m),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
              child: InformedFilledButton.color(
                fillColor: AppColors.brandPrimary,
                disableColor: AppColors.brandPrimary,
                textColor: AppColors.brandSecondary,
                text: LocaleKeys.profile_banner_action.tr(),
                onTap: () => context.pushRoute(const SubscriptionPageRoute()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
