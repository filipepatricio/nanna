import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class UpdatedLabel extends StatelessWidget {
  final DateTime dateTime;
  final Color backgroundColor;

  const UpdatedLabel({required this.dateTime, required this.backgroundColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        _updatedAtLabel().toUpperCase(),
        style: AppTypography.smallerLabelText,
      ),
    );
  }

  String _updatedAtLabel() {
    return LocaleKeys.topic_updated.tr(
      args: [DateFormatUtil.dateTimeFromNow(dateTime)],
    );
  }
}
