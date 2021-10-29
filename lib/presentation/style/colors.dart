import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color limeGreen = Color(0xffBBF383);
  static const Color limeGreenBleached = Color(0x64BBF383);
  static const Color textPrimary = Color(0xff282B35);
  static const Color darkGreyBackground = Color(0xff282B35);
  static const Color lightGrey = Color(0xffFCFAF8);
  static const Color background = Color(0xffFCFAF8);
  static const Color appBarBackground = Color(0xff282B35);
  static const Color transparent = Color(0x00282b35);
  static const Color red = Color(0xffFF6969);
  static const Color blue = Color(0xff4579FF);
  static const Color grey = Color(0xffe7e7e7);
  static const Color rose = Color(0xffF3E5F4);
  static const Color pastelGreen = Color(0xffE4F1E2);
  static const Color beige = Color(0xffF2E8E7);

  static const Color gradientOverlayStartColor = Color(0x90282b35);
  static const Color gradientOverlayEndColor = Color(0x00282B35);

  static Color shadowColor = Colors.black.withOpacity(0.12);
  static Color greyFont = textPrimary.withOpacity(0.44);

  static const Color settingsHeader = Color(0x44282B35);
  static const Color settingsIcon = Color(0xff898A8D);

  static const mockedColors = [
    AppColors.pastelGreen,
    AppColors.rose,
    AppColors.beige,
  ];
}