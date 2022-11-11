part of '../sign_in_page.dart';

class _SignInIdleView extends StatelessWidget {
  const _SignInIdleView({
    required this.isEmailValid,
    required this.keyboardVisible,
    required this.emailController,
    required this.cubit,
  });

  final bool isEmailValid;
  final bool keyboardVisible;
  final TextEditingController emailController;
  final SignInPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          LocaleKeys.signIn_welcome.tr(),
                          style: AppTypography.onBoardingHeader,
                        ),
                        const SizedBox(height: AppDimens.s),
                        Text(
                          LocaleKeys.signIn_header_signIn.tr(),
                          style: AppTypography.b2Regular,
                        ),
                        if (!keyboardVisible) ...[
                          const SizedBox(height: AppDimens.xxl),
                          SignInWithProviderView(onSignInTap: () => cubit.signInWithPlatformProvider()),
                          const SizedBox(height: AppDimens.m),
                          SignInWithLinkedInButton(onTap: () => cubit.signInWithLinkedin()),
                          const SizedBox(height: AppDimens.l),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.lightGrey,
                                  margin: const EdgeInsets.only(right: AppDimens.s),
                                ),
                              ),
                              Text(
                                tr(LocaleKeys.signIn_orContinue),
                                style: AppTypography.b3Medium.copyWith(color: AppColors.darkGrey, height: 1),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.lightGrey,
                                  margin: const EdgeInsets.only(left: AppDimens.s),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppDimens.l),
                        EmailInput(
                          controller: emailController,
                          cubit: cubit,
                          validEmail: isEmailValid,
                        ),
                        const SizedBox(height: AppDimens.m),
                      ],
                    ),
                  ),
                ),
              ),
              if (keyboardVisible) ...[
                FilledButton.black(
                  isEnabled: isEmailValid,
                  text: LocaleKeys.common_signUp.tr(),
                  onTap: () => cubit.sendMagicLink(),
                ),
                const SizedBox(height: AppDimens.m),
              ] else ...[
                const _TermsPolicy(),
                const SizedBox(height: AppDimens.xl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
