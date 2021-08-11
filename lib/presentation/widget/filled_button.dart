import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilledButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final String? iconPath;
  final Color fillColor;

  const FilledButton({
    required this.onTap,
    required this.text,
    this.fillColor = AppColors.limeGreen,
    this.iconPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconPath = this.iconPath;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.s, horizontal: AppDimens.l),
        decoration: BoxDecoration(
          color: onTap == null ? AppColors.lightGrey : fillColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTypography.button.copyWith(
                color: onTap == null ? AppColors.textPrimary.withOpacity(0.44) : AppColors.textPrimary,
              ),
            ),
            if (iconPath != null) ...[
              const SizedBox(width: AppDimens.s),
              SvgPicture.asset(iconPath),
            ],
          ],
        ),
      ),
    );
  }
}
