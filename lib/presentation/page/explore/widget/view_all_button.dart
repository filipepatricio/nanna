import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.darkLinen,
          borderRadius: BorderRadius.circular(AppDimens.s),
        ),
        child: Center(
          child: Text(
            LocaleKeys.explore_viewAll.tr(args: [title]),
            style: AppTypography.b3Medium.copyWith(color: AppColors.darkerGrey),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
