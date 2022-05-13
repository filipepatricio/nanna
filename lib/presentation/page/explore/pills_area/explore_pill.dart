import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExplorePill extends StatelessWidget {
  const ExplorePill({
    required this.title,
    required this.icon,
    required this.index,
    required this.onTap,
    this.color = AppColors.white,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? icon;
  final int index;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.explorePillHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.dividerGreyLight,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.sl,
          horizontal: AppDimens.l,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgPicture.string(icon!),
              const SizedBox(width: AppDimens.s),
            ],
            Text(
              title,
              style: AppTypography.b3Regular.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
