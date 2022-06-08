import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData get mainTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        backgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: AppTypography.navbarText,
          unselectedLabelStyle: AppTypography.navbarText,
          selectedItemColor: AppColors.textPrimary,
          unselectedItemColor: AppColors.textPrimary,
        ),
      );

  static SystemUiOverlayStyle systemUIOverlayStyleDark = SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarDividerColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle systemUIOverlayStyleLight = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarDividerColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
