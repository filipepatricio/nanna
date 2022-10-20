import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/category_pill.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/cover_opacity.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/shadows.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_dotted_info.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_labels_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_labels_section.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/locker.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'article_audio_view_cover.dart';
part 'article_cover_bookmark.dart';
part 'article_cover_daily_brief_large.dart';
part 'article_cover_daily_brief_list.dart';
part 'article_cover_daily_brief_small.dart';
part 'article_cover_explore.dart';
part 'article_cover_other_brief.dart';
part 'article_cover_topic_big_image.dart';
part 'article_cover_topic_without_image.dart';
part 'article_square_cover.dart';

const _coverSizeToScreenWidthFactor = 0.27;

enum ArticleCoverType {
  small,
  list,
  dailyBriefLarge,
  dailyBriefSmall,
  dailyBriefList,
  otherBriefItemsList,
  bookmark,
  audioView,
  topicBigImage,
  topicWithoutImage,
}

class ArticleCover extends StatelessWidget {
  const ArticleCover._(
    this._type, {
    required this.article,
    this.coverColor,
    this.onTap,
    this.height,
    this.width,
    this.shouldShowTimeToRead,
    this.shouldShowAudioIcon,
    this.editorsNote,
    this.backgroundColor,
    this.mediaItemKey,
    this.snackbarController,
    Key? key,
  }) : super(key: key);

  factory ArticleCover.small({
    required MediaItemArticle article,
    required SnackbarController snackbarController,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.small,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
        snackbarController: snackbarController,
      );

  factory ArticleCover.list({
    required MediaItemArticle article,
    required SnackbarController snackbarController,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.list,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
        snackbarController: snackbarController,
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
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.dailyBriefSmall,
        article: article,
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

  factory ArticleCover.bookmark({
    required MediaItemArticle article,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.bookmark,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
      );

  factory ArticleCover.audioView({
    required MediaItemArticle article,
    required double height,
    required double width,
    Color coverColor = AppColors.transparent,
    bool shouldShowTimeToRead = true,
    bool shouldShowAudioIcon = true,
  }) =>
      ArticleCover._(
        ArticleCoverType.audioView,
        article: article,
        height: height,
        width: width,
        coverColor: coverColor,
        shouldShowTimeToRead: shouldShowTimeToRead,
        shouldShowAudioIcon: shouldShowAudioIcon,
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

  factory ArticleCover.dailyBriefList({
    required MediaItemArticle article,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.dailyBriefList,
        article: article,
        backgroundColor: backgroundColor,
        onTap: onTap,
      );

  final ArticleCoverType _type;
  final MediaItemArticle article;
  final VoidCallback? onTap;
  final Color? coverColor;
  final double? height;
  final double? width;
  final bool? shouldShowTimeToRead;
  final bool? shouldShowAudioIcon;
  final String? editorsNote;
  final Color? backgroundColor;
  final GlobalKey? mediaItemKey;
  final SnackbarController? snackbarController;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case ArticleCoverType.small:
        return _ArticleCoverSmall(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
          snackbarController: snackbarController!,
        );
      case ArticleCoverType.list:
        return _ArticleCoverList(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
          snackbarController: snackbarController!,
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
        );
      case ArticleCoverType.otherBriefItemsList:
        return _ArticleCoverOtherBriefItemsList(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
        );
      case ArticleCoverType.audioView:
        return _ArticleAudioViewCover(
          article: article,
          cardColor: coverColor!,
          height: height!,
          width: width!,
          shouldShowTimeToRead: shouldShowTimeToRead!,
          shouldShowAudioIcon: shouldShowAudioIcon!,
        );
      case ArticleCoverType.bookmark:
        return _ArticleCoverBookmark(
          article: article,
          coverColor: coverColor,
          onTap: onTap,
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
      case ArticleCoverType.dailyBriefList:
        return _ArticleCoverDailyBriefListItem(
          coverColor: backgroundColor,
          article: article,
          onTap: onTap,
        );
    }
  }
}
