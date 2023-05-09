part of '../sign_in_page.dart';

class _SignInTermsView extends StatelessWidget {
  const _SignInTermsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        style: AppTypography.sansTextNanoLausanne.copyWith(
          color: AppColors.of(context).textTertiary,
        ),
        children: [
          TextSpan(text: context.l10n.signIn_consentParts_info),
          TextSpan(
            text: context.l10n.signIn_consentParts_terms,
            style: AppTypography.sansTextNanoLausanne.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.of(context).textPrimary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.pushRoute(
                    SettingsTermsOfServicePageRoute(
                      fromRoute: context.l10n.signIn_welcome,
                    ),
                  ),
          ),
          TextSpan(text: context.l10n.signIn_consentParts_and),
          TextSpan(
            text: context.l10n.signIn_consentParts_privacy,
            style: AppTypography.sansTextNanoLausanne.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.of(context).textPrimary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.pushRoute(
                    SettingsPrivacyPolicyPageRoute(
                      fromRoute: context.l10n.signIn_welcome,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
