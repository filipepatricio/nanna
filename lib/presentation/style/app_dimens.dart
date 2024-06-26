import 'dart:math';

import 'package:better_informed_mobile/presentation/util/device_type.dart';
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

  /// 16.0
  static const backArrowSize = 17.0;

  /// 44.0
  static const settingsItemHeight = 44.0;

  /// 50
  static const buttonHeight = 50.0;

  /// 52
  static const onboardingIconSize = 52.0;

  /// 164
  static const logoWidth = 164.0;

  /// 35
  static const logoHeight = 35.0;

  /// 90
  static const calendarAppBar = 90.0;

  /// [kToolbarHeight] + 8
  static const appBarHeight = kToolbarHeight + s;

  /// 0.85
  static const topicCardWidthViewportFraction = 0.85;

  /// 24
  static const avatarSize = 24.0;

  /// 24
  static const smallAvatarSize = 16.0;

  /// 64
  static const avatarSizeBig = 64.0;

  /// 45
  static const topicViewTopicHeaderPadding = 45.0;

  /// 350.0
  static const topicCardBigMaxHeight = 375.0;

  /// MediaQuery.of(context).size.width
  static double topicCardBigMaxWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// 0.4
  static const exploreTopicCarouselSmallCoverWidthFactor = 0.43;

  /// 1.65
  static const exploreArticleCarouselSmallCoverAspectRatio = 2.1;

  static double smallCardWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * AppDimens.exploreTopicCarouselSmallCoverWidthFactor;

  static double smallCardHeight(BuildContext context) =>
      smallCardWidth(context) * AppDimens.exploreTopicCarouselSmallCoverAspectRatio;

  /// 1.65
  static const exploreTopicCarouselSmallCoverAspectRatio = 2.1;

  /// 0.50
  static const exploreTopicCellSizeFactor = 0.50;

  /// 32
  static const audioControlButtonSize = AppDimens.xl;

  /// 16.0
  static const audioViewControlButtonSize = 60.0;

  /// 131
  static const onboardingGridCard = 131.0;

  /// [topicViewHeaderImageHeight] + [topicViewTopicHeaderPadding]
  static double topicArticleSectionTriggerPoint(BuildContext context) =>
      topicViewHeaderImageHeight(context) +
      topicViewTopicHeaderPadding +
      kToolbarHeight +
      MediaQuery.of(context).viewPadding.bottom;

  /// Full screen topic image height
  static double topicViewHeaderImageHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - (AppDimens.audioBannerHeight + MediaQuery.of(context).padding.bottom);

  /// Full screen topic image width
  static double topicViewHeaderImageWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// Full screen article image height
  static double articleHeaderImageHeight(BuildContext context) => articleHeaderImageWidth(context);

  /// Full screen article image width
  static double articleHeaderImageWidth(BuildContext context) =>
      MediaQuery.of(context).size.width - pageHorizontalMargin;

  /// The smallest value from 75% of screen height and 500
  static double topicViewMediaItemMaxHeight(BuildContext context) => min(MediaQuery.of(context).size.height * .75, 500);

  // [MediaQuery.padding.top] or [kToolbarHeight], whichever is higher
  static double articlePageContentTopPadding(BuildContext context) =>
      max(MediaQuery.of(context).padding.top, kToolbarHeight);

  /// 322
  static const articleSmallImageCoverHeight = 322;

  //// 0.35
  static const coverSizeToScreenWidthFactor = 0.35;

  /// 343/228
  static const articleLargeCoverAspectRatio = 343 / 228;

  /// 128/128
  static const articleSmallCoverAspectRatio = 128 / 128;

  /// 45
  static const topicViewStackedCardsDividerHeight = 45.0;

  /// Full screen width
  static double photoCaptionImageContainerWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// 65% Full screen height
  static double photoCaptionImageContainerHeight(BuildContext context) => MediaQuery.of(context).size.height * .65;

  /// 32
  static double explorePillHeight(BuildContext context) => MediaQuery.of(context).textScaleFactor * 32;

  /// 32
  static const bookmarkIconSize = 32.0;

  /// 1024
  static const articleAudioCoverSize = 1024;

  /// 68
  static const audioBannerHeight = 68.0;

  /// 42
  static const searchBarHeight = 36.0;

  static double textHeight({required TextStyle style, required int maxLines}) =>
      (style.fontSize! * 1.05 * (style.height ?? 1)) * maxLines;

  static double safeTopPadding(BuildContext context) => MediaQuery.of(context).padding.top;

  // 320
  static const minWidth = 320.0;

  // 768
  static const maxWidth = 768.0;

  // 720
  static const shareWidth = 720.0;

  // 1080
  static const shareHeight = 1280.0;

  static double coverSize(BuildContext context, double widthFactor) => MediaQuery.of(context).size.width * widthFactor;

  static double strokeAudioWidth(double progressSize) => progressSize * 0.04;

  /// 42
  static const customCheckboxSize = 24.0;

  static const customCheckboxIconSize = 17.0;

  static const pageHorizontalMargin = AppDimens.m;

  static const explorePageSectionBottomPadding = AppDimens.s;

  // Radius

  /// 4
  static const defaultRadius = 4.0;

  /// 8
  static const modalRadius = 8.0;

  /// 8
  static const bottomSheetRadius = 16.0;

  /// 2
  static const iconRadius = 2.0;

  /// 70
  static const pillRadius = 70.0;

  /// 20.0
  static const smallPublisherLogoSize = 20.0;

  /// 24.0
  static const mediumPublisherLogoSize = 24.0;

  /// 40%
  static const unavailableItemOpacity = 0.4;

  /// 50%
  static const offlineIconOpacity = 0.5;

  /// 48px
  static const actionsWidth = AppDimens.xxxl;

  /// 116.0
  static const backButtonWidth = 116.0;

  /// 0.8
  static final minScaleFactor = DeviceType.small.scaleFactor;

  /// 1.5
  static const maxScaleFactor = 2.0;
}
