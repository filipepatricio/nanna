part of '../sign_in_page.dart';

class _TermsPolicy extends HookWidget {
  const _TermsPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();

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
              ..onTap = () => _openInBrowser(context, termsOfServiceUri, snackbarController),
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
              ..onTap = () => _openInBrowser(context, policyPrivacyUri, snackbarController),
          ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser(BuildContext context, String uri, SnackbarController controller) async {
    await openInAppBrowser(
      uri,
      (error, stacktrace) {
        showBrowserError(context, uri, controller);
      },
    );
  }
}
