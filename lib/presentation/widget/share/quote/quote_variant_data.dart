import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';

const quoteVariantDataList = [
  QuoteVariantData._(
    backgroundColor: AppColors.lightGrey,
    foregroundColor: AppColors.textPrimary,
    withTextMark: false,
    iconPath: AppVectorGraphics.newspaper,
  ),
  QuoteVariantData._(
    backgroundColor: AppColors.rose,
    foregroundColor: AppColors.textPrimary,
    withTextMark: true,
  ),
  QuoteVariantData._(
    backgroundColor: AppColors.pastelGreen,
    foregroundColor: AppColors.textPrimary,
    withTextMark: true,
  ),
  QuoteVariantData._(
    backgroundColor: AppColors.peach10,
    foregroundColor: AppColors.textPrimary,
    withTextMark: true,
  ),
  QuoteVariantData._(
    backgroundColor: AppColors.darkGreyBackground,
    foregroundColor: AppColors.white,
    withTextMark: false,
  ),
];

class QuoteVariantData {
  const QuoteVariantData._({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.withTextMark,
    this.iconPath,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final bool withTextMark;
  final String? iconPath;
}
