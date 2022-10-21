import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_provider_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInWithAppleButton extends StatelessWidget {
  const SignInWithAppleButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SignInWithProviderButton(
      label: LocaleKeys.signIn_providerButton_apple.tr(),
      icon: SvgPicture.asset(
        AppVectorGraphics.appleSignIn,
        height: AppDimens.l,
      ),
      onTap: onTap,
    );
  }
}
