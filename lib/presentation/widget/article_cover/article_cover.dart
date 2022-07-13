import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_dotted_info.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_labels_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'article_cover_bookmark_list.dart';
part 'article_cover_daily_brief_large.dart';
part 'article_cover_daily_brief_small.dart';
part 'article_cover_explore.dart';
part 'article_cover_other_brief.dart';
part 'article_cover_topic_big_image.dart';
part 'article_cover_topic_without_image.dart';

const _coverSizeToScreenWidthFactor = 0.26;

const articleCoverShadows = [
  BoxShadow(offset: Offset(0, 10), blurRadius: 80, spreadRadius: -4, color: AppColors.shadowLinenColor),
  BoxShadow(offset: Offset(0, 2), blurRadius: 4, spreadRadius: 0, color: AppColors.shadowLinenColor),
];

enum ArticleCoverType {
  exploreCarousel,
  exploreList,
  dailyBriefLarge,
  dailyBriefSmall,
  otherBriefItemsList,
  bookmarkList,
  topicBigImage,
  topicWithoutImage
}

class ArticleCover extends StatelessWidget {
  const ArticleCover._(
    this._type, {
    required this.article,
    this.coverColor,
    this.onTap,
    this.height,
    this.width,
    this.shouldShowAudioIcon,
    this.shouldShowTextOverlay,
    this.editorsNote,
    this.backgroundColor,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  factory ArticleCover.exploreCarousel({
    required MediaItemArticle article,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.exploreCarousel,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
      );

  factory ArticleCover.exploreList({
    required MediaItemArticle article,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.exploreList,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
      );

  factory ArticleCover.dailyBriefLarge({
    required MediaItemArticle article,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.dailyBriefLarge,
        article: article,
        onTap: onTap,
      );

  factory ArticleCover.dailyBriefSmall({
    required MediaItemArticle article,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.dailyBriefSmall,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
      );

  factory ArticleCover.otherBriefItemsList({
    required MediaItemArticle article,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.otherBriefItemsList,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
      );

  factory ArticleCover.bookmarkList({
    required MediaItemArticle article,
    required double height,
    required double width,
    Color coverColor = AppColors.transparent,
    bool shouldShowTextOverlay = true,
    bool shouldShowAudioIcon = true,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.bookmarkList,
        article: article,
        height: height,
        width: width,
        coverColor: coverColor,
        onTap: onTap,
        shouldShowAudioIcon: shouldShowAudioIcon,
        shouldShowTextOverlay: shouldShowTextOverlay,
      );

  factory ArticleCover.topicBigImage({
    required MediaItemArticle article,
    String? editorsNote,
    VoidCallback? onTap,
    GlobalKey? mediaItemKey,
  }) =>
      ArticleCover._(
        ArticleCoverType.topicBigImage,
        article: article,
        editorsNote: editorsNote,
        onTap: onTap,
        mediaItemKey: mediaItemKey,
      );

  factory ArticleCover.topicWithoutImage({
    required MediaItemArticle article,
    required Color backgroundColor,
    String? editorsNote,
    VoidCallback? onTap,
    GlobalKey? mediaItemKey,
  }) =>
      ArticleCover._(
        ArticleCoverType.topicWithoutImage,
        article: article,
        editorsNote: editorsNote,
        backgroundColor: backgroundColor,
        onTap: onTap,
        mediaItemKey: mediaItemKey,
      );

  final ArticleCoverType _type;
  final MediaItemArticle article;
  final VoidCallback? onTap;
  final Color? coverColor;
  final double? height;
  final double? width;
  final bool? shouldShowTextOverlay;
  final bool? shouldShowAudioIcon;
  final String? editorsNote;
  final Color? backgroundColor;
  final GlobalKey? mediaItemKey;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case ArticleCoverType.exploreCarousel:
        return _ArticleCoverExploreCarousel(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
        );
      case ArticleCoverType.exploreList:
        return _ArticleCoverExploreList(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
        );
      case ArticleCoverType.dailyBriefLarge:
        return _ArticleCoverDailyBriefLarge(
          onTap: onTap,
          article: article,
        );
      case ArticleCoverType.dailyBriefSmall:
        return _ArticleCoverDailyBriefSmall(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
        );
      case ArticleCoverType.otherBriefItemsList:
        return _ArticleCoverOtherBriefItemsList(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
        );
      case ArticleCoverType.bookmarkList:
        return _ArticleCoverBookmarkList(
          article: article,
          cardColor: coverColor!,
          height: height!,
          width: width!,
          shouldShowAudioIcon: shouldShowAudioIcon!,
          shouldShowTextOverlay: shouldShowTextOverlay!,
          onTap: () => AutoRouter.of(context).push(
            MediaItemPageRoute(article: article),
          ),
        );
      case ArticleCoverType.topicBigImage:
        return _ArticleCoverTopicBigImage(
          key: mediaItemKey,
          article: article,
          editorsNote: editorsNote,
          onTap: onTap,
        );
      case ArticleCoverType.topicWithoutImage:
        return _ArticleCoverTopicWithoutImage(
          key: mediaItemKey,
          article: article,
          editorsNote: editorsNote,
          backgroundColor: backgroundColor!,
          onTap: onTap,
        );
    }
  }
}
