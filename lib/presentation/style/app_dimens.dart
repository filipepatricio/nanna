import 'dart:math';

import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:flutter/material.dart';

class AppDimens {
  const AppDimens._();

  ///0.0
  static const zero = 0.0;

  ///1.0
  static const one = 1.0;

  ///2.0
  static const xxs = 2.0;

  ///4.0
  static const xs = 4.0;

  ///8.0
  static const s = 8.0;

  ///12.0
  static const sl = 12.0;

  ///16.0
  static const m = 16.0;

  ///20.0
  static const ml = 20.0;

  ///24.0
  static const l = 24.0;

  ///32.0
  static const xl = 32.0;

  ///40.0
  static const xxl = 40.0;

  ///48.0
  static const xxxl = 48.0;

  ///56.0
  static const c = 56.0;

  ///64.0
  static const xc = 64.0;

  ///72.0
  static const xxc = 72.0;

  ///80.0
  static const xxxc = 80.0;

  /// 4
  static const indicatorSize = 4.0;

  /// 14
  static const naviBarFontSize = 14.0;

  /// 14
  static const backArrowSize = 18.0;

  /// 14
  static const readMoreArrowSize = 14.0;

  /// 16
  static const indicatorSelectedSize = 16.0;

  /// 70
  static const appBarSize = 70.0;

  /// 43
  static const settingsItemHeight = 43.0;

  /// 67
  static const settingsCancelButtonWidth = 67.0;

  /// 30
  static const settingsCancelButtonHeight = 30.0;

  /// 16
  static const topicCardRadius = 16.0;

  /// 16
  static const topicCardBlurRadius = 16.0;

  /// 3
  static const topicCardOffsetY = 3.0;

  /// 36
  static const topicControlsMargin = 36.0;

  /// 8
  static const buttonRadius = 8.0;

  ///50
  static const buttonHeight = 50.0;

  /// 10
  static const articleItemMargin = 10.0;

  /// 84
  static const articleItemPhotoSize = 84.0;

  /// 40
  static const articlePublisherLogoSize = 40;

  /// 4
  static const verticalIndicatorWidth = 4.0;

  /// 92
  static const topicAppBarDefaultHeight = 92.0;

  /// 80
  static const topicAppBarAnimationFactor = 80.0;

  /// 52
  static const onboardingIconSize = 52.0;

  /// 164
  static const logoWidth = 164.0;

  /// 35
  static const logoHeight = 35.0;

  /// 20
  static const shareBottomSheetRadius = 20.0;

  /// 0.85
  static const topicCardWidthViewportFraction = 0.85;

  /// 42
  static const avatarSize = 32.0;

  /// 45
  static const topicViewTopicHeaderPadding = 45.0;

  /// 290
  static const topicViewSummaryCardHeight = 290.0;

  static double topicViewHeaderImageHeight(BuildContext context) =>
      min(MediaQuery.of(context).size.height * .75, topicViewArticleSectionFullHeight);

  /// 45
  static final topicViewStackedCardsDividerHeight = kIsSmallDevice ? 0.0 : 45.0;

  /// 327
  static final topicViewArticleSectionImageHeight = kIsSmallDevice ? 283.0 : 270.0;

  /// 327
  static final topicViewArticleSectionNoteHeight = kIsSmallDevice ? 0.0 : 120.0;

  /// 145 or 195 + topicViewArticleSectionImageHeight + topicViewArticleSectionNoteHeight + topicViewStackedCardsDividerHeight
  static final topicViewArticleSectionFullHeight = (kIsSmallDevice ? 145.0 : 195.0) +
      topicViewArticleSectionImageHeight +
      topicViewArticleSectionNoteHeight +
      topicViewStackedCardsDividerHeight;

  /// 72
  static const topicViewArticleSectionArticleCountLabelHeight = 72.0;

  /// 366
  static const exploreAreaFeaturedArticleHeight = 366.0;

  /// 155
  static const exploreAreaArticleListItemWidth = 155.0;

  /// 260
  static const exploreAreaArticleListItemHeight = 260.0;

  /// 260
  static const exploreAreaArticleSeeAllCoverHeight = 260.0;

  /// 260
  static const exploreAreaTopicSeeAllCoverHeight = 250.0;
}
