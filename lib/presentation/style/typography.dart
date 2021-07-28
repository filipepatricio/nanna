import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

const fontFamilyLora = 'Lora';
const fontFamilyPlusJakartaSans = 'PlusJakartaSans';

class AppTypography {
  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  static const TextStyle h1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.05,
    color: AppColors.textPrimary,
  );

  static const TextStyle primaryTextJakarta = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    color: AppColors.textPrimary,
    fontSize: 16.0,
    height: 1.33,
  );

  static const TextStyle h2Jakarta = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    color: AppColors.textPrimary,
    fontSize: 16.0,
    height: 1.33,
  );
}
