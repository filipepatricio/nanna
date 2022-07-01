import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_labels_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_cover_content.dart';
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
part 'article_cover_other_brief.dart';
part 'article_cover_explore.dart';

const _coverSizeToScreenWidthFactor = 0.26;

enum ArticleCoverType { exploreCarousel, exploreList, dailyBriefLarge, dailyBriefSmall, otherBrief, bookmarkList }

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

  factory ArticleCover.otherBrief({
    required MediaItemArticle article,
    Color? coverColor,
    VoidCallback? onTap,
  }) =>
      ArticleCover._(
        ArticleCoverType.otherBrief,
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

  final ArticleCoverType _type;
  final MediaItemArticle article;
  final VoidCallback? onTap;
  final Color? coverColor;
  final double? height;
  final double? width;
  final bool? shouldShowTextOverlay;
  final bool? shouldShowAudioIcon;

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
      case ArticleCoverType.otherBrief:
        return _ArticleCoverOtherBriefList(
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
    }
  }
}
