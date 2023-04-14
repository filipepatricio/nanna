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
                          context.l10n.signIn_welcome,
                          style: AppTypography.onBoardingHeader,
                        ),
                        const SizedBox(height: AppDimens.s),
                        Text(
                          context.l10n.signIn_header_signIn,
                          style: AppTypography.b2Regular,
                        ),
                        if (!keyboardVisible) ...[
                          const SizedBox(height: AppDimens.xxl),
                          SignInWithGoogleButton(onTap: () => cubit.signInWithGoogle()),
                          const SizedBox(height: AppDimens.m),
                          if (kIsAppleDevice) ...[
                            SignInWithAppleButton(onTap: () => cubit.signInWithApple()),
                            const SizedBox(height: AppDimens.m),
                          ],
                          SignInWithLinkedInButton(onTap: () => cubit.signInWithLinkedin()),
                          const SizedBox(height: AppDimens.l),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: AppDimens.one,
                                  color: AppColors.of(context).borderPrimary,
                                  margin: const EdgeInsets.only(right: AppDimens.s),
                                ),
                              ),
                              Text(
                                context.l10n.signIn_orContinue,
                                style: AppTypography.b3Medium.copyWith(
                                  color: AppColors.of(context).textTertiary,
                                  height: 1,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: AppDimens.one,
                                  color: AppColors.of(context).borderPrimary,
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
                InformedFilledButton.primary(
                  context: context,
                  isEnabled: isEmailValid,
                  text: context.l10n.common_continue,
                  onTap: cubit.sendMagicLink,
                ),
                const SizedBox(height: AppDimens.m),
              ] else ...[
                const _SignInTermsView(),
                const SizedBox(height: AppDimens.xl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
