part of '../sign_in_page.dart';

class _SignInTermsView extends StatelessWidget {
  const _SignInTermsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTypography.metadata1Regular.copyWith(
          color: AppColors.of(context).textTertiary,
        ),
        children: [
          TextSpan(text: context.l10n.signIn_consentParts_info),
          TextSpan(
            text: context.l10n.signIn_consentParts_terms,
            style: AppTypography.metadata1Regular.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              color: AppColors.of(context).textSecondary,
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
            style: AppTypography.metadata1Regular.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              color: AppColors.of(context).textSecondary,
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
