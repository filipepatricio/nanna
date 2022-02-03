import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/magic_link_view.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_with_provider_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

final _emailInputKey = GlobalKey();

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SignInPageCubit>();
    final state = useCubitBuilder(cubit);
    final emailController = useTextEditingController();
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<SignInPageCubit, SignInPageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        success: (state) => AutoRouter.of(context).replaceAll(
          [
            if (!state.isOnboardingSeen) const OnboardingPageRoute() else const MainPageRoute(),
          ],
        ),
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
      body: Container(
        color: AppColors.background,
        child: KeyboardVisibilityBuilder(
          builder: (context, visible) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: SnackbarParentView(
              controller: snackbarController,
              child: state.maybeMap(
                processing: (_) => const Loader(),
                magicLink: (state) => const MagicLinkContent(),
                idle: (state) => _IdleContent(
                  cubit: cubit,
                  isEmailValid: state.emailCorrect,
                  keyboardVisible: visible,
                  emailController: emailController,
                  snackbarController: snackbarController,
                ),
                orElse: () => const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  final bool isEmailValid;
  final bool keyboardVisible;
  final TextEditingController emailController;
  final SignInPageCubit cubit;
  final SnackbarController snackbarController;

  const _IdleContent({
    required this.isEmailValid,
    required this.keyboardVisible,
    required this.emailController,
    required this.cubit,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

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
                    children: [
                      const SizedBox(height: AppDimens.xxc),
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
                        SignInWithProviderView(onSignInTap: () => cubit.signInWithProvider()),
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
                      _EmailInput(
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

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final SignInPageCubit cubit;
  final bool validEmail;

  const _EmailInput({
    required this.controller,
    required this.cubit,
    required this.validEmail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: _emailInputKey,
      controller: controller,
      onChanged: cubit.updateEmail,
      style: AppTypography.input1Medium,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintStyle: AppTypography.input1Medium.copyWith(color: AppColors.black.withOpacity(0.64)),
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
  final SignInPageCubit cubit;
  final bool isEmailValid;

  const _SignInButton({
    required this.cubit,
    required this.isEmailValid,
    Key? key,
  }) : super(key: key);

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
