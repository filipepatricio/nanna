import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';

class UpdatedLabel extends StatelessWidget {
  final DateTime dateTime;
  final Color backgroundColor;

  const UpdatedLabel({required this.dateTime, required this.backgroundColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      padding: const EdgeInsets.all(AppDimens.s),
      child: Text(
        _updatedAtLabel().toUpperCase(),
        style: AppTypography.labelText,
      ),
    );
  }

  String _updatedAtLabel() {
    return LocaleKeys.topic_updated.tr(
      args: ['${Jiffy(dateTime).fromNow()}'],
    );
  }
}
