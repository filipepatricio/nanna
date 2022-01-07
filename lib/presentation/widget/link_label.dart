import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  final String labelText;
  final Color foregroundColor;
  final double fontSize;
  final MainAxisAlignment horizontalAlignment;
  final void Function() onTap;

  const LinkLabel({
    required this.labelText,
    required this.onTap,
    this.foregroundColor = AppColors.textPrimary,
    this.fontSize = 14,
    this.horizontalAlignment = MainAxisAlignment.start,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(AppDimens.ml),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: horizontalAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            labelText,
            style: AppTypography.h5BoldSmall.copyWith(
              decoration: TextDecoration.underline,
              fontSize: fontSize,
              height: 1.0,
              color: foregroundColor,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(width: AppDimens.xs),
          Icon(Icons.arrow_forward_ios_rounded, size: AppDimens.readMoreArrowSize, color: foregroundColor),
        ],
      ),
    );
  }
}
