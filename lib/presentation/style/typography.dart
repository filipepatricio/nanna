import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

const fontFamilyLora = 'Lora';
const fontFamilyPlusJakartaSans = 'PlusJakartaSans';

class AppTypography {
  static const TextStyle hBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 44,
    color: AppColors.textPrimary,
  );

  static const TextStyle h0SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 36,
    color: AppColors.textPrimary,
  );

  static const TextStyle h0Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 36,
    color: AppColors.textPrimary,
  );

  static const TextStyle h1Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  static const TextStyle h1SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyLora,
    fontSize: 24,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  static const TextStyle h1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 28,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  static const TextStyle h1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 28,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2Jakarta = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.33,
  );

  static const TextStyle h2Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 20,
    height: 1.61,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3Bold16 = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3Normal = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 18,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 18,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3boldLoraItalic = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyLora,
    fontStyle: FontStyle.italic,
    fontSize: 18,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4Normal = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.93,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline4Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.34,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle h5BoldSmall = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 1.85,
    color: AppColors.textPrimary,
  );

  static const TextStyle h5MediumSmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 1.85,
    color: AppColors.textPrimary,
  );

  static const TextStyle subH1Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 2.21,
    color: AppColors.textPrimary,
  );

  static const TextStyle subH1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 2.21,
    color: AppColors.textPrimary,
  );

  static const TextStyle subH1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 2.21,
    color: AppColors.textPrimary,
  );

  static const TextStyle subH2BoldSmall = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 10,
    height: 1.366,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle subH2RegularSmall = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 10,
    height: 2.58,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle b0Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 18,
    height: 1.75,
    color: AppColors.textPrimary,
  );

  static const TextStyle b1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle b1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.61,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle b0RegularLora = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyLora,
    fontSize: 18,
    height: 1.75,
    color: AppColors.textPrimary,
  );

  static const b2RegularLora = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyLora,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle b2MediumLora = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyLora,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle b3Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 1.61,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle b3Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 2.31,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle b4MediumSmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 12,
    height: 2.15,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle metadata1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 12,
    height: 1.83,
    color: AppColors.textPrimary,
  );
  static const TextStyle metadata1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 12,
    height: 1.83,
    color: AppColors.textPrimary,
  );

  static const TextStyle metadata2Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 1.28,
    letterSpacing: -0.08,
    color: AppColors.textPrimary,
  );

  static const TextStyle metadata2Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 1.28,
    color: AppColors.textPrimary,
  );

  static const TextStyle metadata2BoldLoraItalic = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyLora,
    fontStyle: FontStyle.italic,
    fontSize: 14,
    height: 1.28,
    letterSpacing: 0.7,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyLora,
    fontSize: 18,
    height: 1.75,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelText = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 9,
    letterSpacing: 1,
    color: AppColors.textPrimary,
  );

  static const TextStyle systemText = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 14,
    height: 1.61,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1,
    color: AppColors.textPrimary,
  );

  static const TextStyle input1Medium = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 2.02,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle input1MediumSmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.93,
    color: AppColors.textPrimary,
  );

  static const TextStyle navbarText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 12,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );
}
