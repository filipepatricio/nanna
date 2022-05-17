import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.sl),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: AppDimens.one,
            color: AppColors.black,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.s),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppVectorGraphics.linkedinSignIn,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: AppDimens.m),
            Text(
              LocaleKeys.signIn_providerButton_linkedin.tr(),
              style: AppTypography.b2Regular,
            ),
          ],
        ),
      ),
    );
  }
}
