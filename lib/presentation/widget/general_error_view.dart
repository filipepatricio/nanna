import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralErrorView extends StatelessWidget {
  GeneralErrorView({
    required this.title,
    required this.content,
    this.svgPath,
    this.retryCallback,
    String? action,
    Key? key,
  })  : action = action ?? LocaleKeys.common_tryAgain.tr(),
        super(key: key);
  final String title;
  final String content;
  final String action;
  final String? svgPath;
  final VoidCallback? retryCallback;

  @override
  Widget build(BuildContext context) {
    final svg = svgPath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (svg != null) ...[
          SvgPicture.asset(svg),
          const SizedBox(height: AppDimens.l),
        ],
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$title\n',
                style: AppTypography.h3bold,
              ),
              TextSpan(
                text: content,
                style: AppTypography.h3Normal,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
          child: retryCallback != null
              ? FilledButton(
                  text: action,
                  fillColor: AppColors.textPrimary,
                  textColor: AppColors.white,
                  onTap: () {
                    retryCallback?.call();
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
