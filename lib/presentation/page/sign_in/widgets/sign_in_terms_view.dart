part of '../sign_in_page.dart';

class _TermsPolicy extends HookWidget {
  const _TermsPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();

    return RichText(
      text: TextSpan(
        style: AppTypography.metadata1Regular.copyWith(color: AppColors.neutralGrey),
        children: [
          TextSpan(text: LocaleKeys.signIn_consentParts_info.tr()),
          TextSpan(
            text: LocaleKeys.signIn_consentParts_terms.tr(),
            style: AppTypography.metadata1Regular.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              color: AppColors.charcoal,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _openInBrowser(termsOfServiceUri, snackbarController),
          ),
          TextSpan(text: LocaleKeys.signIn_consentParts_and.tr()),
          TextSpan(
            text: LocaleKeys.signIn_consentParts_privacy.tr(),
            style: AppTypography.metadata1Regular.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              color: AppColors.charcoal,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _openInBrowser(policyPrivacyUri, snackbarController),
          ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser(String uri, SnackbarController controller) async {
    await openInAppBrowser(
      uri,
      (error, stacktrace) {
        showBrowserError(uri, controller);
      },
    );
  }
}
