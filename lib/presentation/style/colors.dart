import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);
  static const Color limeGreen = Color(0xffBBF383);
  static const Color limeGreenBleached = Color(0x64BBF383);
  static const Color textPrimary = Color(0xff282B35);
  static const Color onboardingBackground = Color(0xff282B35);
  static const Color bottomNaviBackground = Color(0xffFCFAF8);
  static const Color background = Color(0xffE5E5E5);
  static const Color appBarBackground = Color(0xff282B35);
  static const Color transparent = Color(0x00282b35);

  static const Color gradientOverlayStartColor = Color(0xFF282B35);
  static const Color gradientOverlayEndColor = Color(0x00282B35);

  static Color shadowColor = Colors.black.withOpacity(0.12);
}

abstract class AppColorsBase {
  late Color white;
  late Color black;
  late Color limeGreen;
  late Color textPrimary;
  late Color background;
}

class AppStandardColors implements AppColorsBase {
  @override
  Color background = AppColors.background;

  @override
  Color black = AppColors.black;

  @override
  Color limeGreen = AppColors.limeGreen;

  @override
  Color textPrimary = AppColors.textPrimary;

  @override
  Color white = AppColors.white;
}
