part of '../sign_in_page.dart';

class _SignInIdleView extends StatelessWidget {
  const _SignInIdleView({
    required this.isModal,
    required this.isEmailValid,
    required this.keyboardVisible,
    required this.emailController,
    required this.cubit,
  });

  final bool isEmailValid;
  final bool isModal;
  final bool keyboardVisible;
  final TextEditingController emailController;
  final SignInPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: FocusScope.of(context).unfocus,
        child: _ConditionalScrollableWrapper(
          wrap: isModal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isModal ? l10n.signIn_welcome : l10n.signIn_welcome_subscribed,
                      style: AppTypography.sansTitleLargeLausanne,
                    ),
                    const SizedBox(height: AppDimens.m),
                    if (isModal)
                      const SubscriptionBenefits()
                    else
                      Text(
                        l10n.signIn_subscribed_body,
                        style: AppTypography.sansTextSmallLausanne.copyWith(
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    if (!keyboardVisible) ...[
                      const SizedBox(height: AppDimens.xl),
                      if (kIsAppleDevice) ...[
                        SignInWithAppleButton(onTap: () => cubit.signInWithApple()),
                        const SizedBox(height: AppDimens.m),
                      ],
                      SignInWithGoogleButton(onTap: () => cubit.signInWithGoogle()),
                      const SizedBox(height: AppDimens.m),
                      SignInWithLinkedInButton(onTap: () => cubit.signInWithLinkedin()),
                      const SizedBox(height: AppDimens.l),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.signIn_orContinue,
                            style: AppTypography.b3Medium.copyWith(
                              color: AppColors.of(context).textTertiary,
                              height: 1,
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
                    const SizedBox(height: AppDimens.l),
                  ],
                ),
                if (keyboardVisible) ...[
                  InformedFilledButton.primary(
                    context: context,
                    isEnabled: isEmailValid,
                    text: l10n.signIn_withEmailButton,
                    onTap: cubit.sendMagicLink,
                  ),
                  const SizedBox(height: AppDimens.m),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.xxl),
                  child: _SignInTermsView(),
                ),
                const SizedBox(height: AppDimens.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionalScrollableWrapper extends StatelessWidget {
  const _ConditionalScrollableWrapper({
    required this.wrap,
    required this.child,
  });

  final bool wrap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return wrap
        ? Center(
            child: SingleChildScrollView(
              physics: getPlatformScrollPhysics(),
              child: child,
            ),
          )
        : Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: child,
            ),
          );
  }
}
