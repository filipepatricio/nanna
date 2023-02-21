import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/string_util.dart';
import 'package:flutter/material.dart';

class UpdatedLabel extends StatelessWidget {
  const UpdatedLabel({
    required this.dateTime,
    this.fontSize = 14,
    this.textStyle = AppTypography.systemText,
    this.withPrefix = true,
    this.color,
    super.key,
  });

  final DateTime dateTime;
  final double? fontSize;
  final TextStyle textStyle;
  final bool withPrefix;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      withPrefix
          ? context.l10n.topic_updated(DateFormatUtil.dateTimeFromNow(dateTime))
          : DateFormatUtil.dateTimeFromNow(dateTime).toCapitalized(),
      style: textStyle.copyWith(
        height: 1,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
