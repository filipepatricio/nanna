import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/widgets.dart';

class UpdatedLabel extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const UpdatedLabel({required this.text, required this.backgroundColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.s),
        child: Text(text, style: AppTypography.labelText),
      ),
    );
  }
}
