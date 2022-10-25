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
          elevation: 0,
          backgroundColor: AppColors.background,
          selectedLabelStyle: AppTypography.navbarText,
          unselectedLabelStyle: AppTypography.navbarUnselectedText,
          selectedItemColor: AppColors.textPrimary,
          unselectedItemColor: AppColors.neutralGrey,
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
