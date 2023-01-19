import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class NewTag extends StatelessWidget {
  const NewTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.s),
      decoration: BoxDecoration(
        color: AppColors.brandAccent,
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      child: Text(
        LocaleKeys.common_new.tr(),
        style: AppTypography.sansTextNanoLausanne.copyWith(height: 1),
      ),
    );
  }
}
