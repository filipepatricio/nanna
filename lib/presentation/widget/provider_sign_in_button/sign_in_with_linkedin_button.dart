import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_provider_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInWithLinkedInButton extends StatelessWidget {
  const SignInWithLinkedInButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SignInWithProviderButton(
      label: LocaleKeys.signIn_providerButton_linkedin.tr(),
      icon: SvgPicture.asset(
        AppVectorGraphics.linkedinSignIn,
        width: AppDimens.l,
        height: AppDimens.l,
      ),
      onTap: onTap,
    );
  }
}