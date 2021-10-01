import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilledButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback? onTap;
  final String? iconPath;
  final Color fillColor;

  const FilledButton({
    required this.text,
    this.isEnabled = true,
    this.onTap,
    this.fillColor = AppColors.limeGreen,
    this.iconPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconPath = this.iconPath;

    return GestureDetector(
      onTap: isEnabled ? onTap : () => {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.s,
          horizontal: AppDimens.l,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? fillColor : AppColors.lightGrey,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.buttonRadius),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTypography.buttonBold.copyWith(
                color: isEnabled ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.44),
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
