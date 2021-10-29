import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const _radius = 6.0;
const _appleLogoFontSize = 23.0;
const _textFontSize = 20.0;
const _textLetterSpacing = 0.38;

class SignInWithAppleButton extends StatelessWidget {
  final VoidCallback onTap;

  const SignInWithAppleButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.s, horizontal: AppDimens.l),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(_radius),
          ),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _appleLogoFontSize,
                ),
              ),
              Text(
                ' ' + LocaleKeys.signIn_providerButton_apple.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: _textFontSize,
                  letterSpacing: _textLetterSpacing,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
