import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_tile_cover.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnRemoveBookmarkPressed = void Function(Bookmark bookmark);

class BookmarkListTile extends StatelessWidget {
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
    return Column(
      children: [
        const SizedBox(height: AppDimens.m),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.ml,
              ),
              child: bookmarkCover.getContent(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.sl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _BookmarkRemoveButton(
                    onRemoveBookmarkPressed: () => onRemoveBookmarkPressed(
                      bookmarkCover.bookmark,
                    ),
                  ),
                  const SizedBox(width: AppDimens.xs),
                  bookmarkCover.bookmark.getShareButton(context, snackbarController),
                ],
              ),
            ),
          ],
        ),
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
}

extension on BookmarkTileCover {
  Widget getContent(BuildContext context) {
    return map(
      standard: (_) {
        return bookmark.data.mapOrNull(
              article: (data) => ArticleCover.bookmark(
                article: data.article,
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
