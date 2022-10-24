import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_tile_cover.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnRemoveBookmarkPressed = void Function(Bookmark bookmark);

class BookmarkListTile extends HookWidget {
  const BookmarkListTile({
    required this.bookmarkCover,
    required this.onRemoveBookmarkPressed,
    required this.snackbarController,
    required this.cubit,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  final BookmarkTileCover bookmarkCover;
  final OnRemoveBookmarkPressed onRemoveBookmarkPressed;
  final SnackbarController snackbarController;
  final BookmarkListViewCubit cubit;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final articleProgress = useState<ArticleProgress?>(null);

    useEffect(() {
      articleProgress.value = cubit.getCurrentReadProgress(bookmarkCover.bookmark.data);
    });

    return Column(
      children: [
        const SizedBox(height: AppDimens.m),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.ml,
          ),
          child: bookmarkCover.getContent(
            context,
            articleProgress,
            snackbarController,
          ),
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

extension on BookmarkTileCover {
  Future<void> goToArticle(
    BuildContext context,
    MediaItemArticle article,
    ValueNotifier<ArticleProgress?> articleProgress,
  ) async {
    final progress = await AutoRouter.of(context).push<ArticleProgress?>(
      MediaItemPageRoute(article: article),
    );
    articleProgress.value = progress;
  }

  Widget getContent(
    BuildContext context,
    ValueNotifier<ArticleProgress?> articleProgress,
    SnackbarController snackbarController,
  ) {
    return map(
      standard: (_) {
        return bookmark.data.mapOrNull(
              article: (data) => ArticleCover.list(
                article: data.article,
                onTap: () => goToArticle(context, data.article, articleProgress),
                snackbarController: snackbarController,
                // TODO: we need to overwrite bookmark removing with custom onRemoveBookmarkPressed callback
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
              articleProgress,
              snackbarController,
            ) ??
            const SizedBox.shrink();
      },
    );
  }

  Widget? _createDynamicCover(
    BuildContext context,
    int index,
    Bookmark bookmark,
    ValueNotifier<ArticleProgress?> articleProgress,
    SnackbarController snackbarController,
  ) {
    return bookmark.data.mapOrNull(
      article: (data) => ArticleCover.list(
        article: data.article,
        onTap: () => goToArticle(context, data.article, articleProgress),
        snackbarController: snackbarController,
      ),
      //TODO: Replace with TopicCover.big
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
