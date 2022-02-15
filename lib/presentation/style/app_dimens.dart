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

  /// 14
  static const backArrowSize = 18.0;

  /// 14
  static const readMoreArrowSize = 14.0;

  /// 43
  static const settingsItemHeight = 43.0;

  /// 8
  static const buttonRadius = 8.0;

  ///50
  static const buttonHeight = 50.0;

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
  static const topicViewSummaryCardHeight = 330.0;

  static const topicViewSummaryTextHeight = 300.0;

  static double topicArticleSectionTriggerPoint(BuildContext context) =>
      AppDimens.topicViewHeaderImageHeight(context) +
      AppDimens.topicViewTopicHeaderPadding +
      AppDimens.topicViewSummaryCardHeight;

  /// 75% of screen size or [topicViewArticleSectionFullHeight], whichever is smaller
  static double topicViewHeaderImageHeight(BuildContext context) => min(
        MediaQuery.of(context).size.height * .75,
        topicViewArticleSectionFullHeight(context),
      );

  static double topicViewMediaItemMaxHeight(BuildContext context) => min(MediaQuery.of(context).size.height * .70, 500);

  /// 0 / 45
  static double topicViewStackedCardsDividerHeight(BuildContext context) => context.isSmallDevice ? 0.0 : 45.0;

  /// 283 / 270
  static double topicViewArticleSectionImageHeight(BuildContext context) => context.isSmallDevice ? 283.0 : 270.0;

  /// 0 : 120
  static double topicViewArticleSectionNoteHeight(BuildContext context) => context.isSmallDevice ? 0.0 : 120.0;

  /// 145 or 195 + topicViewArticleSectionImageHeight + topicViewArticleSectionNoteHeight + topicViewStackedCardsDividerHeight
  static double topicViewArticleSectionFullHeight(BuildContext context) =>
      (context.isSmallDevice ? 145.0 : 195.0) +
      topicViewArticleSectionImageHeight(context) +
      topicViewArticleSectionNoteHeight(context) +
      topicViewStackedCardsDividerHeight(context);

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
