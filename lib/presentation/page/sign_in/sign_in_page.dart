import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/magic_link_view.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_with_provider_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/sign_in_with_linkedin_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

final _emailInputKey = GlobalKey();
const _loadingLogo = Padding(
  padding: EdgeInsets.only(bottom: kToolbarHeight),
  child: LoaderLogo(),
);

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SignInPageCubit>();
    final state = useCubitBuilder(cubit);
    final emailController = useTextEditingController();
    final snackbarController = useMemoized(() => SnackbarController());

    void showSnackbar(String message) => snackbarController.showMessage(
          SnackbarMessage.simple(
            message: message,
            type: SnackbarMessageType.negative,
          ),
        );

    useOnAppLifecycleStateChange((previous, current) {
      if (current != previous && current == AppLifecycleState.resumed) {
        cubit.cancelLinkedInSignIn();
      }
    });

    useCubitListener<SignInPageCubit, SignInPageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        success: (state) => AutoRouter.of(context).replaceAll(
          [
            if (!state.isOnboardingSeen) const OnboardingPageRoute() else const MainPageRoute(),
          ],
        ),
        unauthorizedError: (_) => showSnackbar(LocaleKeys.signIn_unauthorized.tr()),
        generalError: (_) => showSnackbar(LocaleKeys.common_generalError.tr()),
        orElse: () {},
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        leading: state.maybeMap(
          magicLink: (_) => Padding(
            padding: const EdgeInsets.only(left: AppDimens.m + AppDimens.xxs),
            child: IconButton(
              icon: const Icon(Icons.close_rounded),
              color: AppColors.textPrimary,
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: () {
                cubit.closeMagicLinkView();
              },
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: KeyboardVisibilityBuilder(
          builder: (context, visible) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: SnackbarParentView(
              controller: snackbarController,
              child: state.maybeMap(
                processing: (_) => _loadingLogo,
                processingLinkedIn: (_) => _loadingLogo,
                magicLink: (state) => MagicLinkContent(email: state.email),
                idle: (state) => _IdleContent(
                  cubit: cubit,
                  isEmailValid: state.emailCorrect,
                  keyboardVisible: visible,
                  emailController: emailController,
                  snackbarController: snackbarController,
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  const _IdleContent({
    required this.isEmailValid,
    required this.keyboardVisible,
    required this.emailController,
    required this.cubit,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final bool isEmailValid;
  final bool keyboardVisible;
  final TextEditingController emailController;
  final SignInPageCubit cubit;
  final SnackbarController snackbarController;

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
              const SizedBox(height: AppDimens.m),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(
                          AppVectorGraphics.informedLogoDark,
                          width: AppDimens.logoWidth,
                          height: AppDimens.logoHeight,
                        ),
                      ),
                      const SizedBox(height: AppDimens.l),
                      Text(
                        LocaleKeys.signIn_header_signIn.tr(),
                        style: AppTypography.h3Normal.copyWith(fontSize: 19, height: 1.47, letterSpacing: 0.15),
                      ),
                      if (!keyboardVisible) ...[
                        const SizedBox(height: AppDimens.xl),
                        SignInWithProviderView(onSignInTap: () => cubit.signInWithPlatformProvider()),
                        const SizedBox(height: AppDimens.m),
                        SignInWithLinkedInButton(onTap: () => cubit.signInWithLinkedin()),
                        const SizedBox(height: AppDimens.xxl),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.dividerGrey,
                                margin: const EdgeInsets.only(right: AppDimens.s),
                              ),
                            ),
                            Text(
                              tr(LocaleKeys.signIn_orContinue),
                              style: AppTypography.b3Regular.copyWith(color: AppColors.darkGrey, height: 1),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.dividerGrey,
                                margin: const EdgeInsets.only(left: AppDimens.s),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.xl),
                        Text(
                          tr(LocaleKeys.signIn_emailLabel),
                          style: AppTypography.b3Regular,
                        ),
                      ],
                      const SizedBox(height: AppDimens.s),
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
                _SignInButton(cubit: cubit, isEmailValid: isEmailValid),
                const SizedBox(height: AppDimens.m),
              ] else ...[
                _TermsPolicy(snackbarController: snackbarController),
                const SizedBox(height: AppDimens.xxl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({
    required this.controller,
    required this.cubit,
    required this.validEmail,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final SignInPageCubit cubit;
  final bool validEmail;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      key: _emailInputKey,
      controller: controller,
      onChanged: cubit.updateEmail,
      style: AppTypography.b2Regular.copyWith(
        height: 2.02,
        letterSpacing: 0.15,
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintStyle: AppTypography.b2Regular.copyWith(
          height: 2.02,
          letterSpacing: 0.15,
          color: AppColors.black40,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.black),
          borderRadius: BorderRadius.circular(AppDimens.sl),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.black),
          borderRadius: BorderRadius.circular(AppDimens.sl),
        ),
        contentPadding: const EdgeInsets.only(left: AppDimens.m),
      ),
      maxLines: 1,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.none,
      onSubmitted: validEmail ? (value) => cubit.sendMagicLink() : null,
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.cubit,
    required this.isEmailValid,
    Key? key,
  }) : super(key: key);
  final SignInPageCubit cubit;
  final bool isEmailValid;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      disableColor: AppColors.dividerGrey,
      fillColor: AppColors.black,
      isEnabled: isEmailValid,
      textColor: AppColors.white,
      text: LocaleKeys.common_signUp.tr(),
      onTap: () => cubit.sendMagicLink(),
    );
  }
}

class _TermsPolicy extends StatelessWidget {
  const _TermsPolicy({
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.b3Regular,
        children: [
          TextSpan(text: LocaleKeys.signIn_consentParts_info.tr()),
          TextSpan(
            text: LocaleKeys.signIn_consentParts_terms.tr(),
            style: AppTypography.b3Regular.copyWith(color: AppColors.blue),
            recognizer: TapGestureRecognizer()..onTap = () => _openInBrowser(termsOfServiceUri),
          ),
          TextSpan(text: LocaleKeys.signIn_consentParts_and.tr()),
          TextSpan(
            text: LocaleKeys.signIn_consentParts_privacy.tr(),
            style: AppTypography.b3Regular.copyWith(color: AppColors.blue),
            recognizer: TapGestureRecognizer()..onTap = () => _openInBrowser(policyPrivacyUri),
          ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser(String uri) async {
    await openInAppBrowser(
      uri,
      (error, stacktrace) {
        showBrowserError(uri, snackbarController);
      },
    );
  }
}
