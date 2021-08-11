import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_with_provider_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

final _emailInputKey = GlobalKey();
const _inputBarHeight = 48.0;
const _inputBarWidth = 4.0;

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SignInPageCubit>();
    final state = useCubitBuilder(cubit);
    final emailController = useTextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // We will have image here later
            // image: DecorationImage(
            //   image: AssetImage(''),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Container(
          color: AppColors.darkGreyBackground,
          child: KeyboardVisibilityBuilder(
            builder: (context, visible) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state.maybeMap(
                processing: (_) => const Loader(),
                magicLink: (state) => const _MagicLinkContent(),
                idle: (state) => _IdleContent(
                  cubit: cubit,
                  isEmailValid: state.emailCorrect,
                  keyboardVisible: visible,
                  emailController: emailController,
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

class _MagicLinkContent extends StatelessWidget {
  const _MagicLinkContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.xxc),
            Text(
              LocaleKeys.signIn_header_magicLink.tr(),
              style: AppTypography.h1Bold.copyWith(color: AppColors.lightGrey),
            ),
            const Spacer(),
            Center(
              child: SvgPicture.asset(AppVectorGraphics.mail),
            ),
            const Spacer(flex: 2),
          ],
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

  const _IdleContent({
    required this.isEmailValid,
    required this.keyboardVisible,
    required this.emailController,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.xxc),
            Text(
              LocaleKeys.signIn_header_signIn.tr(),
              style: AppTypography.h1Bold.copyWith(color: AppColors.lightGrey),
            ),
            if (!keyboardVisible) ...[
              const SizedBox(height: AppDimens.xl),
              const SignInWithProviderView(),
            ],
            const SizedBox(height: AppDimens.xxc),
            _EmailInput(
              controller: emailController,
              cubit: cubit,
            ),
            const Spacer(),
            if (keyboardVisible) ...[
              _SignInButton(cubit: cubit, isEmailValid: isEmailValid),
              const SizedBox(height: AppDimens.m),
            ] else ...[
              const _Consents(),
              const SizedBox(height: AppDimens.xxl),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final SignInPageCubit cubit;

  const _EmailInput({
    required this.controller,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _inputBarWidth,
          height: _inputBarHeight,
          color: AppColors.lightGrey,
        ),
        const SizedBox(width: AppDimens.s),
        Expanded(
          child: TextField(
            key: _emailInputKey,
            controller: controller,
            onChanged: cubit.updateEmail,
            style: AppTypography.input1Medium.copyWith(color: AppColors.limeGreen),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: LocaleKeys.signIn_emailHint.tr(),
              hintStyle: AppTypography.input1Medium.copyWith(color: AppColors.lightGrey.withOpacity(0.64)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 11), // TODO find a better way to center TextField content
            ),
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ],
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
      text: LocaleKeys.common_signUp.tr(),
      onTap: isEmailValid ? () => cubit.sendMagicLink() : null,
    );
  }
}

class _Consents extends StatelessWidget {
  const _Consents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.b3Regular.copyWith(color: AppColors.lightGrey),
        children: [
          TextSpan(text: LocaleKeys.signIn_consentParts_info.tr()),
          TextSpan(
            text: LocaleKeys.signIn_consentParts_terms.tr(),
            style: AppTypography.b3Regular.copyWith(color: AppColors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AutoRouter.of(context).push(
                  SettingsPolicyTermsPageRoute(isPolicy: false),
                );
              },
          ),
          TextSpan(text: LocaleKeys.signIn_consentParts_and.tr()),
          TextSpan(
            text: LocaleKeys.signIn_consentParts_privacy.tr(),
            style: AppTypography.b3Regular.copyWith(color: AppColors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AutoRouter.of(context).push(
                  SettingsPolicyTermsPageRoute(isPolicy: true),
                );
              },
          ),
        ],
      ),
    );
  }
}
