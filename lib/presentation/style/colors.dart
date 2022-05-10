import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // How to set opacity in Hex https://gist.github.com/lopspower/03fb1cc0ac9f32ef38f4

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color black40 = Color(0x66000000);
  static const Color black20 = Color(0x33000000);
  static const Color limeGreen = Color(0xffBBF383);
  static const Color limeGreenVivid = Color(0xffA2F054);
  static const Color limeGreenDark = Color(0xff6AE476);
  static const Color textGrey = Color(0xff989898);
  static const Color darkGreyBackground = Color(0xff282B35);
  static const Color linen = Color(0xffFCFAF8);
  static const Color darkLinen = Color(0xffF4F1EE);
  static const Color transparent = Color(0x00000000);
  static const Color blue = Color(0xff4579FF);
  static const Color grey = Color(0xffe7e7e7);
  static const Color grey04 = Color(0xff5F5F5F);
  static const Color rose = Color(0xffF3E5F4);
  static const Color pastelGreen = Color(0xffE4F1E2);
  static const Color pastelPurple = Color(0xffDFBFFF);
  static const Color darkGrey = Color(0xff6B7280);
  static const Color carrotRed = Color(0xffFB6F43);
  static const Color peach = Color(0xffF2E8E7);
  static const Color blueSelected = Color(0xff0099FF);

  static const Color background = linen;
  static const Color textPrimary = darkGreyBackground;

  static const Color shadowLinenColor = Color(0x336B6346);
  static const Color shadowColor = Color(0x1f000000);

  static const Color settingsHeader = Color(0x44282B35);
  static const Color settingsIcon = Color(0xff898A8D);

  static const Color socialNetworksIcon = Color(0x80282B35);

  static const Color dividerGrey = Color(0xffD1D5DB);
  static const Color dividerGreyLight = Color(0xffE5E5EA);

  static const mockedColors = [
    AppColors.pastelGreen,
    AppColors.rose,
    AppColors.peach,
  ];
}
