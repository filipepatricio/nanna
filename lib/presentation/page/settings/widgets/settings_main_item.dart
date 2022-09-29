import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsMainItem extends StatelessWidget {
  const SettingsMainItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppDimens.settingsItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.b2Medium.copyWith(height: 1)),
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
