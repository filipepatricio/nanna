import 'dart:math';

import 'package:flutter/material.dart';

class AppDimens {
  const AppDimens._();

  /// 0.0
  static const zero = 0.0;

  /// 1.0
  static const one = 1.0;

  /// 2.0
  static const xxs = 2.0;

  /// 4.0
  static const xs = 4.0;

  /// 8.0
  static const s = 8.0;

  /// 12.0
  static const sl = 12.0;

  /// 16.0
  static const m = 16.0;

  /// 20.0
  static const ml = 20.0;

  /// 24.0
  static const l = 24.0;

  /// 32.0
  static const xl = 32.0;

  /// 40.0
  static const xxl = 40.0;

  /// 48.0
  static const xxxl = 48.0;

  /// 56.0
  static const c = 56.0;

  /// 64.0
  static const xc = 64.0;

  /// 72.0
  static const xxc = 72.0;

  /// 80.0
  static const xxxc = 80.0;

  /// 18.0
  static const backArrowSize = 18.0;

  /// 44.0
  static const settingsItemHeight = 44.0;

  /// 8
  static const buttonRadius = 8.0;

  /// 50
  static const buttonHeight = 50.0;

  /// 52
  static const onboardingIconSize = 52.0;

  /// 164
  static const logoWidth = 164.0;

  /// 35
  static const logoHeight = 35.0;

  /// 20
  static const shareBottomSheetRadius = 20.0;

  /// [kToolbarHeight] + 8
  static const appBarHeight = kToolbarHeight + s;

  /// 0.85
  static const topicCardWidthViewportFraction = 0.85;

  /// 32
  static const avatarSize = 32.0;

  /// 45
  static const topicViewTopicHeaderPadding = 45.0;

  /// 300
  static const topicViewSummaryTextHeight = 300.0;

  /// 350.0
  static const briefEntryCardStackHeight = 350.0;

  /// 0.4
  static const exploreTopicCarousellSmallCoverWidthFactor = 0.4;

  /// 1.65
  static double exploreTopicCarousellSmallCoverAspectRatio = 1.65;

  /// 0.72
  static const exploreTopicCellSizeFactor = 0.72;

  /// [topicViewHeaderImageHeight] + [topicViewTopicHeaderPadding] + [topicViewSummaryTextHeight]
  static double topicArticleSectionTriggerPoint(BuildContext context) =>
      topicViewHeaderImageHeight(context) +
      topicViewTopicHeaderPadding +
      topicViewSummaryTextHeight +
      kToolbarHeight +
      MediaQuery.of(context).viewPadding.bottom;

  /// Full screen topic image height
  static double topicViewHeaderImageHeight(BuildContext context) => MediaQuery.of(context).size.height;

  /// Full screen topic image width
  static double topicViewHeaderImageWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// Full screen article image height
  static double articleHeaderImageHeight(BuildContext context) => MediaQuery.of(context).size.height;

  /// Full screen article image width
  static double articleHeaderImageWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// The smallest value from 75% of screen height and 500
  static double topicViewMediaItemMaxHeight(BuildContext context) => min(MediaQuery.of(context).size.height * .75, 500);

  /// 410
  static double articleSmallImageCoverHeight = 322;

  /// 45
  static const double topicViewStackedCardsDividerHeight = 45.0;

  /// Full screen width
  static double photoCaptionImageContainerWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// 65% Full screen height
  static double photoCaptionImageContainerHeight(BuildContext context) => MediaQuery.of(context).size.height * .65;

  /// 170
  static const explorePillAreaHeight = 170.0;

  /// 50
  static const explorePillHeight = 50.0;

  /// 32
  static const bookmarkIconSize = 32.0;

  /// 1024
  static const articleAudioCoverSize = 1024;

  /// 80
  static const audioBannerHeight = 80.0;

  /// 42
  static const searchBarHeight = 42.0;

  static double textHeight({required TextStyle style, required int maxLines}) =>
      (style.fontSize! * 1.05 * (style.height ?? 1)) * maxLines;

  static double safeTopPadding(BuildContext context) => MediaQuery.of(context).padding.top;
}
