import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_tile_cover.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnRemoveBookmarkPressed = void Function(Bookmark bookmark);

class BookmarkListTile extends HookWidget {
  const BookmarkListTile({
    required this.bookmarkCover,
    required this.onRemoveBookmarkPressed,
    required this.snackbarController,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  final BookmarkTileCover bookmarkCover;
  final OnRemoveBookmarkPressed onRemoveBookmarkPressed;
  final SnackbarController snackbarController;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final articleProgress = useMemoized(
      () => ValueNotifier<ArticleProgress?>(
        bookmarkCover.bookmark.data.mapOrNull(article: (data) => data.article.progress),
      ),
    );

    return Column(
      children: [
        const SizedBox(height: AppDimens.m),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.ml,
          ),
          child: bookmarkCover.getContent(context, articleProgress),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sl,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<ArticleProgress?>(
                valueListenable: articleProgress,
                builder: (context, value, child) {
                  return bookmarkCover.bookmark.getReadProgressLabel(context, value);
                },
              ),
              Row(
                children: [
                  _BookmarkRemoveButton(
                    onRemoveBookmarkPressed: () => onRemoveBookmarkPressed(
                      bookmarkCover.bookmark,
                    ),
                  ),
                  const SizedBox(width: AppDimens.xs + AppDimens.xxs),
                  bookmarkCover.bookmark.getShareButton(context, snackbarController),
                ],
              ),
            ],
          ),
        ),
        ValueListenableBuilder<ArticleProgress?>(
          valueListenable: articleProgress,
          builder: (context, value, child) {
            return bookmarkCover.bookmark.getReadProgressBar(context, value);
          },
        ),
        const SizedBox(height: AppDimens.m),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.ml,
            ),
            child: InformedDivider(),
          ),
      ],
    );
  }
}

class _BookmarkRemoveButton extends StatelessWidget {
  const _BookmarkRemoveButton({
    required this.onRemoveBookmarkPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onRemoveBookmarkPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemoveBookmarkPressed,
      child: SizedBox.square(
        dimension: AppDimens.bookmarkIconSize,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xs),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: SvgPicture.asset(AppVectorGraphics.heartSelected),
            ),
          ),
        ),
      ),
    );
  }
}

extension on Bookmark {
  Widget getShareButton(
    BuildContext context,
    SnackbarController snackbarController,
  ) {
    return data.map(
      article: (data) => ShareArticleButton(
        backgroundColor: AppColors.transparent,
        article: data.article,
        snackbarController: snackbarController,
      ),
      topic: (data) => ShareButton(
        onTap: (shareOption) => shareTopicArticlesList(
          context,
          data.topic,
          shareOption,
          snackbarController,
        ),
        backgroundColor: AppColors.transparent,
      ),
      unknown: (_) => const SizedBox.shrink(),
    );
  }

  Widget getReadProgressBar(
    BuildContext context,
    ArticleProgress? articleProgress,
  ) {
    final articleProgressValue = articleProgress;
    return articleProgressValue != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.ml),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.s),
              child: LinearProgressIndicator(
                backgroundColor: AppColors.dividerGreyLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkGreyBackground),
                value: articleProgressValue.contentProgress / 100.0,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget getReadProgressLabel(
    BuildContext context,
    ArticleProgress? articleProgress,
  ) {
    final articleProgressValue = articleProgress;
    return articleProgressValue != null
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.s,
            ),
            child: Text(
              LocaleKeys.article_percentageRead.tr(args: ['${(articleProgressValue.contentProgress).ceil()}']),
              style: AppTypography.subH2Bold.copyWith(color: AppColors.darkerGrey),
            ),
          )
        : const SizedBox.shrink();
  }
}

extension on BookmarkTileCover {
  Widget getContent(
    BuildContext context,
    ValueNotifier<ArticleProgress?> articleProgress,
  ) {
    return map(
      standard: (_) {
        return bookmark.data.mapOrNull(
              article: (data) => ArticleCover.bookmark(
                article: data.article,
                onTap: () async {
                  final progress = await AutoRouter.of(context).push<ArticleProgress?>(
                    MediaItemPageRoute(article: data.article),
                  );
                  articleProgress.value = progress;
                },
              ),
              topic: (_) => throw Exception('There should not be topic with static cover'),
            ) ??
            const SizedBox.shrink();
      },
      dynamic: (cover) {
        return _createDynamicCover(
              context,
              cover.indexOfType,
              bookmark,
            ) ??
            const SizedBox.shrink();
      },
    );
  }

  Widget? _createDynamicCover(
    BuildContext context,
    int index,
    Bookmark bookmark,
  ) {
    return bookmark.data.mapOrNull(
      article: (data) => ArticleCover.bookmark(
        article: data.article,
        coverColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
      ),
      topic: (data) => TopicCover.bookmark(
        topic: data.topic.asPreview,
        onTap: () => AutoRouter.of(context).push(
          TopicPage(
            topicSlug: data.topic.slug,
          ),
        ),
      ),
    );
  }
}
