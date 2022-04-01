import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralErrorView extends StatelessWidget {
  final String title;
  final String content;
  final String svgPath;
  final VoidCallback? retryCallback;

  const GeneralErrorView({
    required this.title,
    required this.content,
    required this.svgPath,
    this.retryCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(svgPath),
        const SizedBox(height: AppDimens.l),
        Text(
          title,
          style: AppTypography.h3bold,
          textAlign: TextAlign.center,
        ),
        Text(
          content,
          style: AppTypography.h3Normal,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
          child: retryCallback != null
              ? FilledButton(
                  text: LocaleKeys.common_tryAgain.tr(),
                  fillColor: AppColors.textPrimary,
                  textColor: AppColors.white,
                  onTap: () {
                    retryCallback?.call();
                  },
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
