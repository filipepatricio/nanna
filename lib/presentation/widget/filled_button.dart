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
  final Color textColor;
  final bool isLoading;

  const FilledButton({
    required this.text,
    this.isEnabled = true,
    this.onTap,
    this.fillColor = AppColors.limeGreen,
    this.textColor = AppColors.textPrimary,
    this.iconPath,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconPath = this.iconPath;

    return GestureDetector(
      onTap: isEnabled ? onTap : () => {},
      child: Container(
        height: AppDimens.xxl,
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
            Center(
              child: isLoading
                  ? const SizedBox(
                      height: AppDimens.m,
                      width: AppDimens.m,
                      child: CircularProgressIndicator(color: AppColors.textPrimary, strokeWidth: AppDimens.xxs))
                  : Text(
                      text,
                      style: AppTypography.buttonBold.copyWith(
                        color: isEnabled ? textColor : textColor.withOpacity(0.44),
                      ),
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
