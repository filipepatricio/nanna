import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UpdatedLabel extends StatelessWidget {
  final DateTime dateTime;
  final Color backgroundColor;
  final Brightness mode;
  final double? fontSize;
  final TextStyle textStyle;

  const UpdatedLabel({
    required this.dateTime,
    required this.backgroundColor,
    this.mode = Brightness.dark,
    this.fontSize = 12,
    this.textStyle = AppTypography.systemText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        LocaleKeys.topic_updated.tr(
          args: [DateFormatUtil.dateTimeFromNow(dateTime)],
        ),
        style: textStyle.copyWith(
          height: 1,
          fontSize: fontSize,
          color: mode == Brightness.dark ? null : AppColors.white,
        ),
      ),
    );
  }
}
