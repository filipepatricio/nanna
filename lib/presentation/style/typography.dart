import 'package:flutter/material.dart';

const _fontFamilyIvarText = 'IvarText';
const _fontFamilyIvarHeadline = 'IvarHeadline';
const _fontFamilyLausanne = 'Lausanne';

class AppTypography {
  static final w550 = FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5);

  // Serif Title
  static const TextStyle serifTitleSmallIvar = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 20,
    height: 1.1,
  );

  static const TextStyle serifTitleLargeIvar = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 26,
    height: 1.1,
  );

  // Sans Title
  static const TextStyle sansTitleLargeLausanne = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 28,
    height: 1.1,
  );

  static const TextStyle sansTitleMediumLausanne = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.1,
  );

  static const TextStyle sansTitleSmallLausanne = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 20,
    height: 1.1,
  );

  // Sans Text
  static const TextStyle sansTextSmallLausanne = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 1.5,
  );

  static const TextStyle sansTextNanoLausanne = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 12,
    height: 1.5,
  );

  // Deprecated
  static const TextStyle h1Headline = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyLausanne,
    fontSize: 38,
    height: 1.25,
  );

  static const TextStyle onBoardingHeader = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 36,
  );

  static const TextStyle h0Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 32,
    height: 1.1,
  );

  static const TextStyle h0Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 32,
    height: 1,
  );

  static const TextStyle h1ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.34,
  );

  static const TextStyle h1Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.29,
  );

  static const TextStyle h1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.33,
  );

  static const TextStyle h1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 28,
    height: 1.0,
  );

  static const TextStyle h2Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.33,
  );

  static const TextStyle h2Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.33,
  );

  static const TextStyle h3Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 18,
    height: 1.25,
  );

  static const TextStyle h3bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 18,
    height: 1.25,
  );

  static const TextStyle h4BoldItalic = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontStyle: FontStyle.italic,
    fontSize: 16,
    height: 1.25,
  );

  static const TextStyle h4Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle h4Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle h4Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle h4ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle h5BoldSmall = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 1.85,
  );

  static const TextStyle h5ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: _fontFamilyLausanne,
    fontSize: 24,
    height: 1.5,
  );

  static const TextStyle subH0Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1,
  );

  static const TextStyle subH1Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 2.21,
  );

  static const TextStyle subH1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 1,
  );

  static const TextStyle subH1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 2.21,
  );

  static const TextStyle subH2Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 10,
    height: 1.366,
    letterSpacing: 0.15,
  );

  static const TextStyle subH2Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 10,
    height: 1.2,
  );

  static const TextStyle subH2Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 10,
    height: 1.0,
    letterSpacing: 0.15,
  );

  static const TextStyle b1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 18,
    height: 1.5,
  );

  static const TextStyle b1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 18,
    height: 1.5,
  );

  static const TextStyle b2Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle b2Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle b2Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle b3Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 1.61,
    letterSpacing: 0.15,
  );

  static const TextStyle b3Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 2.31,
    letterSpacing: 0.15,
  );

  static const TextStyle metadata1ExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: _fontFamilyLausanne,
    fontSize: 12,
    height: 1.2,
  );

  static const TextStyle metadata1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 12,
    height: 1.83,
  );

  static const TextStyle metadata1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 12,
    height: 1.83,
  );

  static const TextStyle caption1Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 1.2,
  );

  static const TextStyle labelText = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 9,
    letterSpacing: 1,
  );

  static const TextStyle systemText = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    height: 1.61,
    letterSpacing: 0.15,
  );

  static const TextStyle buttonBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1,
  );

  static const TextStyle buttonRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyLausanne,
    fontSize: 16,
    height: 1,
  );

  static const TextStyle navbarText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    letterSpacing: 0.2,
  );

  static const TextStyle navbarUnselectedText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 14,
    letterSpacing: 0.2,
  );

  static const TextStyle timeLabelText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyLausanne,
    fontSize: 12,
    letterSpacing: 1,
  );

  ///Ivar fonts (External content)

  static const TextStyle articleH0SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 32,
    height: 1.18,
  );

  static const TextStyle articleQuote = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 36,
  );

  static const TextStyle articleTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 24,
    height: 1.33,
  );

  static const TextStyle articleBigTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 18,
    height: 1.33,
  );

  static const TextStyle articleSmallTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamilyIvarHeadline,
    fontSize: 16,
    height: 1.33,
  );

  static const TextStyle articleTextRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamilyIvarText,
    fontSize: 18,
    height: 1.61,
  );

  static const TextStyle articleText = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamilyIvarText,
    fontSize: 18,
    height: 1.61,
  );

  static const TextStyle articleTextBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamilyIvarText,
    fontSize: 18,
    height: 1.61,
  );
}
