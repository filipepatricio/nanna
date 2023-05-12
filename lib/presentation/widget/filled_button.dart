import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class InformedFilledButton extends StatelessWidget {
  const InformedFilledButton._({
    required this.text,
    required this.fillColor,
    required this.disableColor,
    required this.textColor,
    this.subtext,
    this.isEnabled = true,
    this.onTap,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.withOutline = false,
    this.style,
    EdgeInsets? padding,
  }) : padding = padding ?? const EdgeInsets.symmetric(vertical: AppDimens.m, horizontal: AppDimens.l);

  factory InformedFilledButton.accent({
    required BuildContext context,
    required String text,
    String? subtext,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      InformedFilledButton._(
        text: text,
        subtext: subtext,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: AppColors.of(context).buttonAccentBackground,
        disableColor: AppColors.of(context).buttonAccentBackground,
        textColor: AppColors.of(context).buttonAccentText,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  factory InformedFilledButton.primary({
    required BuildContext context,
    required String text,
    String? subtext,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      InformedFilledButton._(
        text: text,
        subtext: subtext,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: AppColors.of(context).buttonPrimaryBackground,
        disableColor: AppColors.of(context).buttonPrimaryBackgroundDisabled,
        textColor: AppColors.of(context).buttonPrimaryText,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  factory InformedFilledButton.negative({
    required String text,
    String? subtext,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      InformedFilledButton._(
        text: text,
        subtext: subtext,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: AppColors.stateBackgroundError,
        disableColor: AppColors.stateBackgroundError,
        textColor: AppColors.stateTextSecondary,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  factory InformedFilledButton.secondary({
    required BuildContext context,
    required String text,
    String? subtext,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
    bool withOutline = true,
  }) =>
      InformedFilledButton._(
        text: text,
        subtext: subtext,
        onTap: onTap,
        fillColor: AppColors.of(context).buttonSecondaryBackground,
        disableColor: AppColors.of(context).buttonSecondaryBackground,
        textColor: AppColors.of(context).buttonSecondaryText,
        leading: leading,
        trailing: trailing,
        withOutline: withOutline,
      );

  factory InformedFilledButton.tertiary({
    required BuildContext context,
    required String text,
    VoidCallback? onTap,
    EdgeInsets? padding,
  }) =>
      InformedFilledButton._(
        text: text,
        onTap: onTap,
        fillColor: AppColors.of(context).buttonSecondaryBackground,
        disableColor: AppColors.of(context).buttonSecondaryBackground,
        textColor: AppColors.of(context).buttonSecondaryText,
        withOutline: true,
        style: AppTypography.sansTextNanoLausanne,
        padding: padding ?? const EdgeInsets.symmetric(vertical: AppDimens.sl, horizontal: AppDimens.l),
      );

  factory InformedFilledButton.color({
    required String text,
    required Color fillColor,
    required Color disableColor,
    required Color textColor,
    String? subtext,
    bool isEnabled = true,
    bool isLoading = false,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
  }) =>
      InformedFilledButton._(
        text: text,
        subtext: subtext,
        isEnabled: isEnabled,
        onTap: onTap,
        fillColor: fillColor,
        disableColor: disableColor,
        textColor: textColor,
        isLoading: isLoading,
        leading: leading,
        trailing: trailing,
      );

  final String text;
  final String? subtext;
  final bool isEnabled;
  final VoidCallback? onTap;
  final Color fillColor;
  final Color disableColor;
  final Color textColor;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final bool withOutline;
  final TextStyle? style;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final trailing = this.trailing;

    final textStyle =
        style ?? (subtext != null ? AppTypography.buttonBold : AppTypography.buttonMedium).copyWith(color: textColor);

    return GestureDetector(
      onTap: isEnabled ? onTap : () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        decoration: BoxDecoration(
          color: isEnabled ? fillColor : disableColor,
          border: withOutline
              ? Border.all(
                  color: AppColors.of(context).borderPrimary,
                  width: 1.0,
                )
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.defaultRadius),
          ),
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                text,
                                style: textStyle.copyWith(
                                  leadingDistribution: TextLeadingDistribution.even,
                                ),
                              ),
                              if (subtext != null) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: AppDimens.s),
                                  child: Text(
                                    subtext!,
                                    style: AppTypography.buttonRegular.copyWith(
                                      color: textColor,
                                      leadingDistribution: TextLeadingDistribution.even,
                                    ),
                                  ),
                                ),
                              ],
                            ],
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
      ),
    );
  }
}
