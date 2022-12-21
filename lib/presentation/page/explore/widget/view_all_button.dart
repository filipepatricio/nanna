import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({
    this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.of(context).backgroundSecondary,
          borderRadius: BorderRadius.circular(AppDimens.defaultRadius),
        ),
        child: Center(
          child: Text(
            LocaleKeys.explore_viewAll.tr(),
            style: AppTypography.b3Medium.copyWith(
              color: AppColors.of(context).textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
