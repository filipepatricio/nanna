import 'package:flutter/material.dart';

/// Idea here is: we don't need to reference colors by their actual name.
///
/// We can reference them by their role. With [AppColors.of(context)] if theme-based colors, or as static if foundational colors
///
/// Foundation colors https://www.figma.com/file/PE9wsgj0OsQiYBta0Jt4Xq/Foundation?node-id=2499%3A975&t=6Z2J1FsLHokIzySd-0
class AppColors {
  const AppColors._({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderTertiary,
    required this.buttonPrimaryBackground,
    required this.buttonPrimaryText,
    required this.buttonPrimaryBackgroundDisabled,
    required this.buttonSecondaryBackground,
    required this.buttonSecondaryText,
    required this.buttonSecondaryFrame,
    required this.buttonAccentBackground,
    required this.buttonAccentText,
    required this.shadowDividerColors,
    required this.blackWhitePrimary,
    required this.blackWhiteSecondary,
  });

  static AppColors of(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        return dark;
      case Brightness.light:
        return light;
    }
  }

  static const light = AppColors._(
    textPrimary: brandPrimary,
    textSecondary: _darkerGrey,
    textTertiary: _neutralGrey,
    backgroundPrimary: brandSecondary,
    backgroundSecondary: _lightGrey,
    iconPrimary: brandPrimary,
    iconSecondary: _neutralGrey,
    borderPrimary: _lightGrey,
    borderSecondary: _neutralGrey,
    borderTertiary: brandPrimary,
    buttonPrimaryBackground: brandPrimary,
    buttonPrimaryText: _white,
    buttonPrimaryBackgroundDisabled: _darkerGrey,
    buttonSecondaryBackground: brandSecondary,
    buttonSecondaryText: brandPrimary,
    buttonSecondaryFrame: _lightGrey,
    buttonAccentBackground: brandAccent,
    buttonAccentText: brandPrimary,
    blackWhitePrimary: _black,
    blackWhiteSecondary: _white,
    shadowDividerColors: [_lightGrey, brandSecondary],
  );

  static const dark = AppColors._(
    textPrimary: brandSecondary,
    textSecondary: _lightGrey,
    textTertiary: _neutralGrey,
    backgroundPrimary: brandPrimary,
    backgroundSecondary: _darkerGrey,
    iconPrimary: brandSecondary,
    iconSecondary: _neutralGrey,
    borderPrimary: _lightGrey,
    borderSecondary: _neutralGrey,
    borderTertiary: brandSecondary,
    buttonPrimaryBackground: brandSecondary,
    buttonPrimaryText: brandPrimary,
    buttonPrimaryBackgroundDisabled: _darkerGrey,
    buttonSecondaryBackground: brandPrimary,
    buttonSecondaryText: brandSecondary,
    buttonSecondaryFrame: _lightGrey,
    buttonAccentBackground: brandAccent,
    buttonAccentText: brandPrimary,
    blackWhitePrimary: _white,
    blackWhiteSecondary: _black,
    shadowDividerColors: [_darkCharcoal, brandPrimary],
  );

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color iconPrimary;
  final Color iconSecondary;
  final Color borderPrimary;
  final Color borderSecondary;
  final Color borderTertiary;
  final Color buttonPrimaryBackground;
  final Color buttonPrimaryText;
  final Color buttonPrimaryBackgroundDisabled;
  final Color buttonSecondaryBackground;
  final Color buttonSecondaryText;
  final Color buttonSecondaryFrame;
  final Color buttonAccentBackground;
  final Color buttonAccentText;
  final Color blackWhitePrimary;
  final Color blackWhiteSecondary;
  final List<Color> shadowDividerColors;

  // How to set opacity in Hex https://gist.github.com/lopspower/03fb1cc0ac9f32ef38f4

  /// charcoal
  static const Color brandPrimary = Color(0xFF252525);

  ///darkLinen
  static const Color brandSecondary = Color(0xFFF8F8F7);

  /// limeGreen
  static const Color brandAccent = Color(0xFFC7F860);

  /// charcoal 40%
  static const Color overlay = Color(0x66252525);

  /// black 20%
  static const Color shadow20 = Color(0x33000000);

  /// black 4%
  static const Color shadow04 = Color(0x0A000000);

  /// _white 0%
  static const Color transparent = Color(0x00000000);

  static const Color stateTextPrimary = _black;
  static const Color stateTextSecondary = _white;
  static const Color stateBackgroundError = Color(0xFFF15147);
  static const Color stateBackgroundWarning = Color(0xFFFFF495);
  static const Color stateBackgroundSuccess = Color(0xFF439E5C);

  static const Color categoriesTextSecondary = _darkerGrey;
  static const Color categoriesBackgroundShowMeEverything = _white;

  static const Color snackBarPositive = stateBackgroundSuccess;
  static const Color snackBarNegative = stateBackgroundError;
  static const Color snackBarInformative = _white;

  static const String shareBackgroundTopColor = "#FFFFFF";
  static const String shareBackgroundBottomColor = "#FFFFFF";

  static const Color _black = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _darkCharcoal = Color(0xFF121212);
  static const Color _darkerGrey = Color(0xFF5F5F5F);
  static const Color _neutralGrey = Color(0xFF989898);
  static const Color _lightGrey = Color(0xFFEEEEEC);

  static MaterialColor getMaterialColorFromColor(Color color) {
    final colorShades = {
      50: _getShade(color, value: 0.5),
      100: _getShade(color, value: 0.4),
      200: _getShade(color, value: 0.3),
      300: _getShade(color, value: 0.2),
      400: _getShade(color, value: 0.1),
      500: color,
      600: _getShade(color, value: 0.1, darker: true),
      700: _getShade(color, value: 0.15, darker: true),
      800: _getShade(color, value: 0.2, darker: true),
      900: _getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }

  static Color _getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((darker ? (hsl.lightness - value) : (hsl.lightness + value)).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
