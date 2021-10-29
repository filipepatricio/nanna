import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsMainItem extends StatelessWidget {
  final String label;
  final String icon;
  final Function onTap;

  const SettingsMainItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: AppDimens.settingsItemHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.h4Medium),
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