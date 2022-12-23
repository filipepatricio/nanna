import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InformedTheme {
  static ThemeData get light => _data(Brightness.light, AppColors.light, ThemeData.light());

  static ThemeData get dark => _data(Brightness.dark, AppColors.dark, ThemeData.dark());

  static SystemUiOverlayStyle systemUIOverlayStyleDark = SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: AppColors.dark.backgroundPrimary,
    systemNavigationBarDividerColor: AppColors.dark.backgroundPrimary,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle systemUIOverlayStyleLight = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: AppColors.light.backgroundPrimary,
    systemNavigationBarDividerColor: AppColors.light.backgroundPrimary,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static ThemeData _data(
    Brightness brightness,
    AppColors colors,
    ThemeData baseData,
  ) =>
      ThemeData(
        brightness: brightness,
        primarySwatch: AppColors.getMaterialColorFromColor(colors.textPrimary),
        backgroundColor: colors.backgroundPrimary,
        scaffoldBackgroundColor: colors.backgroundPrimary,
        splashColor: kIsAppleDevice ? AppColors.transparent : null,
        highlightColor: kIsAppleDevice ? AppColors.transparent : null,
        appBarTheme: AppBarTheme(
          elevation: 0,
          shadowColor: AppColors.overlay,
          foregroundColor: colors.textPrimary,
          backgroundColor: colors.backgroundPrimary,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colors.backgroundPrimary,
          modalBackgroundColor: colors.backgroundPrimary,
        ),
        iconTheme: IconThemeData(color: colors.iconPrimary),
        tabBarTheme: TabBarTheme(
          labelColor: colors.textPrimary,
          unselectedLabelColor: colors.textTertiary,
        ),
        dividerColor: colors.borderPrimary,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: colors.backgroundPrimary,
          selectedLabelStyle: AppTypography.navbarText,
          unselectedLabelStyle: AppTypography.navbarUnselectedText,
          selectedItemColor: colors.textPrimary,
          unselectedItemColor: colors.iconSecondary,
        ),
        textTheme: baseData.textTheme.apply(
          bodyColor: colors.textPrimary,
          displayColor: colors.textPrimary,
          decorationColor: colors.textPrimary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colors.textPrimary,
          selectionColor: AppColors.brandAccent,
          selectionHandleColor: colors.textPrimary,
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: colors.textPrimary,
          primaryContrastingColor: colors.textPrimary,
          barBackgroundColor: colors.backgroundPrimary,
          scaffoldBackgroundColor: colors.backgroundPrimary,
          textTheme: CupertinoTextThemeData(
            primaryColor: colors.textPrimary,
          ),
        ),
      );
}
