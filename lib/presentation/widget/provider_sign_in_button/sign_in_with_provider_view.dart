import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_apple_button.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_google_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInWithProviderView extends HookWidget {
  const SignInWithProviderView({
    required this.onSignInTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onSignInTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        if (kIsAppleDevice) SignInWithAppleButton(onTap: onSignInTap) else SignInWithGoogleButton(onTap: onSignInTap),
      ],
    );
  }
}