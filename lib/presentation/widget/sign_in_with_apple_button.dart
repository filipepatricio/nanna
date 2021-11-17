import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _appleLogoSize = 50.0;

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
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            width: AppDimens.one,
            color: AppColors.black,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.s),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppVectorGraphics.appleSignIn,
              height: _appleLogoSize,
            ),
            Text(
              LocaleKeys.signIn_providerButton_apple.tr(),
              style: AppTypography.b1Regular,
            ),
          ],
        ),
      ),
    );
  }
}
