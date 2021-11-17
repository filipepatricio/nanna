import 'dart:io';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/sign_in_with_apple_button.dart';
import 'package:better_informed_mobile/presentation/widget/sign_in_with_google_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInWithProviderView extends HookWidget {
  final VoidCallback onSignInTap;

  const SignInWithProviderView({
    required this.onSignInTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        if (Platform.isIOS) SignInWithAppleButton(onTap: onSignInTap),
        if (Platform.isAndroid) SignInWithGoogleButton(onTap: onSignInTap),
      ],
    );
  }
}
