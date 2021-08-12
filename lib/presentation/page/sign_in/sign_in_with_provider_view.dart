import 'dart:io';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/sign_in_with_apple_button.dart';
import 'package:better_informed_mobile/presentation/widget/sign_in_with_google_button.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final text = useMemoized(() {
      if (Platform.isIOS) {
        return LocaleKeys.signIn_providerInfo_apple.tr();
      } else if (Platform.isAndroid) {
        return LocaleKeys.signIn_providerInfo_google.tr();
      } else {
        throw Exception('Unknown platform');
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: AppTypography.b3Regular.copyWith(color: AppColors.lightGrey),
        ),
        const SizedBox(height: AppDimens.s),
        if (Platform.isIOS) SignInWithAppleButton(onTap: onSignInTap),
        if (Platform.isAndroid) SignInWithGoogleButton(onTap: onSignInTap),
      ],
    );
  }
}
