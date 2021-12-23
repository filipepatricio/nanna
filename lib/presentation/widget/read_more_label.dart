import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';

class ReadMoreLabel extends StatelessWidget {
  final Color foregroundColor;
  final double fontSize;
  final Function()? onTap;

  const ReadMoreLabel({
    this.onTap,
    this.foregroundColor = AppColors.textPrimary,
    this.fontSize = 14,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(AppDimens.ml),
      onTap: onTap ?? () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.article_readMore.tr(),
            style: AppTypography.h5BoldSmall.copyWith(
              decoration: TextDecoration.underline,
              fontSize: fontSize,
              height: 1.0,
              color: foregroundColor,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(width: AppDimens.s),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12),
        ],
      ),
    );
  }
}
