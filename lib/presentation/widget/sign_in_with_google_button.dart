import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _fontSize = 14.0;

class SignInWithGoogleButton extends StatelessWidget {
  final VoidCallback onTap;

  const SignInWithGoogleButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.s, horizontal: AppDimens.s),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimens.xs),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppVectorGraphics.googleSignIn),
            const SizedBox(width: AppDimens.l),
            Text(
              LocaleKeys.signIn_providerButton_google.tr(),
              style: const TextStyle(
                fontSize: _fontSize,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
