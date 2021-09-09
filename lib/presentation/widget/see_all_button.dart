import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  final VoidCallback onTap;

  const SeeAllButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m, vertical: AppDimens.s),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: AppColors.darkGreyBackground.withOpacity(0.15),
          ),
          borderRadius: BorderRadius.circular(AppDimens.m),
        ),
        child: Center(
          child: Text(
            tr(LocaleKeys.common_seeAll),
            style: AppTypography.systemText.copyWith(height: 1),
          ),
        ),
      ),
    );
  }
}
