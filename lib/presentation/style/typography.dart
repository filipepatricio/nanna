import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:flutter/material.dart';

const fontFamilyLora = 'Lora';
const fontFamilyPlusJakartaSans = 'PlusJakartaSans';

class AppTypography {
  static TextStyle h1Headline(BuildContext context) => TextStyle(
        fontWeight: FontWeight.w800,
        fontFamily: fontFamilyPlusJakartaSans,
        fontSize: context.isSmallDevice ? 28 : 36,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static const TextStyle h0SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 36,
    color: AppColors.textPrimary,
  );

  static const TextStyle h0ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 36,
    height: 1.23,
    color: AppColors.textPrimary,
  );

  static const TextStyle h0Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 36,
    color: AppColors.textPrimary,
  );

  static TextStyle h0Beta(BuildContext context) => TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyPlusJakartaSans,
        fontSize: context.isSmallDevice ? 24 : 34,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static const TextStyle h1ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.34,
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
    height: 1.29,
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
    fontSize: 16,
    height: 1.25,
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

  static const TextStyle h4ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
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

  static const TextStyle h5ExtraBald = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 24,
    height: 1.5,
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

  static const TextStyle b1MediumLora = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyLora,
    fontSize: 18,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle b2Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle b2Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
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

  static const b2RegularLora = TextStyle(
    fontWeight: FontWeight.w400,
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

  static const TextStyle b3MediumLora = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyLora,
    fontSize: 14,
    height: 1.5,
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

  static const b3RegularLora = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyLora,
    fontSize: 14,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle metadata1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 12,
    height: 1.83,
    color: AppColors.textPrimary,
  );

  static const TextStyle articleTextRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyLora,
    fontSize: 18,
    height: 1.61,
    color: AppColors.textPrimary,
  );

  static const TextStyle articleText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyLora,
    fontSize: 18,
    height: 1.61,
    color: AppColors.textPrimary,
  );

  static const TextStyle articleTextBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 18,
    height: 1.61,
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

  static const TextStyle navbarText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 12,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle timeLabelText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyPlusJakartaSans,
    fontSize: 8,
    letterSpacing: 1,
    color: AppColors.textPrimary,
  );
}
