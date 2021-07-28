import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get mainTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
      );
}
