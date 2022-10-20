import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/string_util.dart';
import 'package:flutter/material.dart';

class UpdatedLabel extends StatelessWidget {
  const UpdatedLabel({
    required this.dateTime,
    this.mode = Brightness.dark,
    this.fontSize = 14,
    this.textStyle = AppTypography.systemText,
    this.withPrefix = true,
    Key? key,
  }) : super(key: key);
  final DateTime dateTime;
  final Brightness mode;
  final double? fontSize;
  final TextStyle textStyle;
  final bool withPrefix;

  @override
  Widget build(BuildContext context) {
    return Text(
      withPrefix
          ? LocaleKeys.topic_updated.tr(
              args: [DateFormatUtil.dateTimeFromNow(dateTime)],
            )
          : DateFormatUtil.dateTimeFromNow(dateTime).toCapitalized(),
      style: textStyle.copyWith(
        height: 1,
        fontSize: fontSize,
        color: mode == Brightness.dark ? null : AppColors.white,
      ),
    );
  }
}
