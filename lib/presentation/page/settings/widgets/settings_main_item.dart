import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsMainItem extends StatelessWidget {
  const SettingsMainItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.fontColor,
  });

  final String label;
  final String? icon;
  final VoidCallback onTap;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.b2Medium.copyWith(height: 2, color: fontColor),
            ),
            if (icon != null)
              SvgPicture.asset(
                icon,
                width: AppDimens.l,
                height: AppDimens.l,
                fit: BoxFit.contain,
              )
          ],
        ),
      ),
    );
  }
}
