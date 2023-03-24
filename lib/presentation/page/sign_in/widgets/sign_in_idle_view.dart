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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.l10n.signIn_welcome,
                        style: AppTypography.sansTitleLargeLausanne,
                      ),
                      const SizedBox(height: AppDimens.m),
                      Column(
                        children: [
                          Row(
                            children: [
                              const InformedSvg(
                                height: AppDimens.m,
                                AppVectorGraphics.checkmark,
                              ),
                              const SizedBox(width: AppDimens.s),
                              Text(
                                context.l10n.signIn_description_featureOne,
                                style: AppTypography.sansTextSmallLausanne.copyWith(height: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.s),
                          Row(
                            children: [
                              const InformedSvg(
                                height: AppDimens.m,
                                AppVectorGraphics.checkmark,
                              ),
                              const SizedBox(width: AppDimens.s),
                              Text(
                                context.l10n.signIn_description_featureTwo,
                                style: AppTypography.sansTextSmallLausanne.copyWith(height: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.s),
                          Row(
                            children: [
                              const InformedSvg(
                                height: AppDimens.m,
                                AppVectorGraphics.checkmark,
                              ),
                              const SizedBox(width: AppDimens.s),
                              Text(
                                context.l10n.signIn_description_featureThree,
                                style: AppTypography.sansTextSmallLausanne.copyWith(height: 1),
                              ),
                            ],
                          ),
                        ],
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
                              context.l10n.signIn_orContinue,
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
                      const SizedBox(height: AppDimens.m),
                    ],
                  ),
                ),
              ),
              if (keyboardVisible) ...[
                InformedFilledButton.primary(
                  context: context,
                  isEnabled: isEmailValid,
                  text: context.l10n.signIn_withEmailButton,
                  onTap: cubit.sendMagicLink,
                ),
                const SizedBox(height: AppDimens.m),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.xxl),
                  child: _SignInTermsView(),
                ),
                const SizedBox(height: AppDimens.l),
                Row(
                  children: [
                    Expanded(
                      child: InformedFilledButton.tertiary(
                        context: context,
                        text: context.l10n.subscription_redeemCode,
                        withOutline: true,
                      ),
                    ),
                    const SizedBox(width: AppDimens.s),
                    Expanded(
                      child: InformedFilledButton.tertiary(
                        context: context,
                        text: context.l10n.subscription_restorePurchase,
                        withOutline: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
