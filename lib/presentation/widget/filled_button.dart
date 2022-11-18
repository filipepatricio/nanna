import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  const FilledButton._({
    required this.text,
    this.isEnabled = true,
    this.onTap,
    this.fillColor = AppColors.limeGreen,
    this.disableColor = AppColors.limeGreen,
    this.textColor = AppColors.textPrimary,
    this.disableTextColor = AppColors.charcoal50,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.withOutline = false,
    Key? key,
  }) : super(key: key);

  factory FilledButton.green({
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      FilledButton._(
        text: text,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: AppColors.limeGreen,
        disableColor: AppColors.limeGreen,
        textColor: AppColors.textPrimary,
        disableTextColor: AppColors.charcoal50,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  factory FilledButton.black({
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      FilledButton._(
        text: text,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: AppColors.charcoal,
        disableColor: AppColors.darkerGrey,
        textColor: AppColors.white,
        disableTextColor: AppColors.neutralGrey,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  factory FilledButton.red({
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      FilledButton._(
        text: text,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: AppColors.carrotRed,
        disableColor: AppColors.carrotRed,
        textColor: AppColors.white,
        disableTextColor: AppColors.white50,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  factory FilledButton.white({
    required String text,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
    bool withOutline = false,
  }) =>
      FilledButton._(
        text: text,
        isEnabled: true,
        onTap: onTap,
        fillColor: AppColors.darkLinen,
        disableColor: AppColors.darkLinen,
        textColor: AppColors.charcoal,
        disableTextColor: AppColors.neutralGrey,
        isLoading: false,
        leading: leading,
        trailing: trailing,
        withOutline: withOutline,
      );

  final String text;
  final bool isEnabled;
  final VoidCallback? onTap;
  final Color fillColor;
  final Color disableColor;
  final Color textColor;
  final Color disableTextColor;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final bool withOutline;

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final trailing = this.trailing;
    return GestureDetector(
      onTap: isEnabled ? onTap : () => {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.m,
          horizontal: AppDimens.l,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? fillColor : disableColor,
          border: withOutline
              ? Border.all(
                  color: AppColors.lightGrey,
                  width: 1.0,
                )
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.defaultRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLoading
                  ? SizedBox(
                      height: AppDimens.m,
                      width: AppDimens.m,
                      child: CircularProgressIndicator(color: textColor, strokeWidth: AppDimens.xxs),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leading != null) ...[
                          leading,
                          const SizedBox(width: AppDimens.sl),
                        ],
                        Text(
                          text,
                          style: AppTypography.buttonMedium.copyWith(
                            color: isEnabled ? textColor : disableTextColor,
                          ),
                        ),
                        if (trailing != null) ...[
                          const SizedBox(width: AppDimens.sl),
                          trailing,
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
