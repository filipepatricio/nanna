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

  const UpdatedLabel({
    required this.dateTime,
    required this.backgroundColor,
    this.mode = Brightness.dark,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        LocaleKeys.topic_updated.tr(
          args: [DateFormatUtil.dateTimeFromNow(dateTime)],
        ).toUpperCase(),
        style: AppTypography.smallerLabelText.copyWith(
          color: mode == Brightness.dark ? null : AppColors.white,
        ),
      ),
    );
  }
}
