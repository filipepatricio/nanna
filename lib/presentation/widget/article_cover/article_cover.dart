import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_labels_editors_note.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/article_cover_shadow.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_cover_content.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';

part 'article_cover_bookmark_list.dart';
part 'article_cover_daily_brief_large.dart';
part 'article_cover_daily_brief_small.dart';

const _coverSizeToScreenWidthFactor = 0.26;

enum ArticleCoverType { exploreCarousel, exploreList, dailyBriefLarge, dailyBriefSmall, bookmarkList }

class ArticleCover extends StatelessWidget {
  const ArticleCover._(
    this._type, {
    required this.article,
    this.coverColor,
    this.onTap,
    this.editorsNote,
    this.height,
    this.width,
    this.shouldShowAudioIcon,
    this.shouldShowTextOverlay,
    Key? key,
  }) : super(key: key);

  final ArticleCoverType _type;
  final MediaItemArticle article;
  final VoidCallback? onTap;
  final Color? coverColor;
  final String? editorsNote;
  final double? height;
  final double? width;
  final bool? shouldShowTextOverlay;
  final bool? shouldShowAudioIcon;

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
    String? editorsNote,
  }) =>
      ArticleCover._(
        ArticleCoverType.dailyBriefLarge,
        article: article,
        editorsNote: editorsNote,
      );

  factory ArticleCover.dailyBriefSmall({
    required MediaItemArticle article,
    Color? coverColor,
    String? editorsNote,
  }) =>
      ArticleCover._(
        ArticleCoverType.dailyBriefSmall,
        article: article,
        coverColor: coverColor,
        editorsNote: editorsNote,
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
          article: article,
          editorsNote: editorsNote,
        );
      case ArticleCoverType.dailyBriefSmall:
        return _ArticleCoverDailyBriefSmall(
          article: article,
          coverColor: coverColor,
          editorsNote: editorsNote,
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

class _ArticleCoverExploreCarousel extends StatelessWidget {
  const _ArticleCoverExploreCarousel({
    required this.onTap,
    required this.article,
    required this.coverColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox.square(
              dimension: constraints.maxWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.s),
                child: _CoverImage(
                  article: article,
                  coverColor: coverColor,
                  showArticleIndicator: true,
                ),
              ),
            ),
            ArticleCoverContent(article: article),
          ],
        ),
      ),
    );
  }
}

class _ArticleCoverExploreList extends StatelessWidget {
  const _ArticleCoverExploreList({
    required this.onTap,
    required this.article,
    required this.coverColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    final coverSize = MediaQuery.of(context).size.width * _coverSizeToScreenWidthFactor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: coverSize,
            child: _CoverImage(
              article: article,
              coverColor: coverColor,
              showArticleIndicator: false,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      if (article.publisher.darkLogo != null) PublisherLogo.dark(publisher: article.publisher),
                      Flexible(
                        child: Text(
                          article.publisher.name,
                          maxLines: 1,
                          style: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    article.strippedTitle,
                    maxLines: 2,
                    style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Flexible(
                    child: DottedArticleInfo(
                      article: article,
                      isLight: false,
                      showLogo: false,
                      showDate: true,
                      showReadTime: true,
                      showPublisher: false,
                      fullDate: true,
                      textStyle: AppTypography.caption1Medium,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.article,
    required this.coverColor,
    required this.showArticleIndicator,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final bool showArticleIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.s),
            child: article.hasImage
                ? ArticleImage(
                    image: article.image!,
                    cardColor: coverColor,
                    showDarkened: true,
                  )
                : SizedBox.expand(
                    child: Container(color: coverColor),
                  ),
          ),
        ),
        if (showArticleIndicator)
          Positioned(
            top: AppDimens.s,
            left: AppDimens.s,
            child: CoverLabel.article(),
          ),
        if (article.hasAudioVersion)
          Positioned(
            bottom: AppDimens.s,
            right: AppDimens.s,
            child: CoverLabel.audio(),
          ),
      ],
    );
  }
}