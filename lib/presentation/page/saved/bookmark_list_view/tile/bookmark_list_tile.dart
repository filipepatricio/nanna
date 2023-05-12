import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/saved/bookmark_list_view/bookmark_list_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';

class BookmarkListTile extends StatelessWidget {
  const BookmarkListTile({
    required this.bookmark,
    required this.onRemoveBookmarkPressed,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final Bookmark bookmark;
  final OnRemoveBookmarkPressed onRemoveBookmarkPressed;
  final BookmarkListViewCubit cubit;

  @override
  Widget build(BuildContext context) {
    return bookmark.getContent(
      context,
      () => onRemoveBookmarkPressed(bookmark),
    );
  }
}

extension on Bookmark {
  Widget getContent(
    BuildContext context,
    VoidCallback? onRemoveBookmarkCallback,
  ) {
    return data.map(
      article: (data) => data.article.hasImage
          ? ArticleCover.medium(
              article: data.article,
              onTap: () => context.pushRoute(
                MediaItemPageRoute(
                  article: data.article,
                  openedFrom: context.l10n.main_savedTab,
                ),
              ),
              onBookmarkTap: onRemoveBookmarkCallback,
            )
          : ArticleCover.large(
              article: data.article,
              onTap: () => context.pushRoute(
                MediaItemPageRoute(
                  article: data.article,
                  openedFrom: context.l10n.main_savedTab,
                ),
              ),
              showNote: true,
              showRecommendedBy: true,
            ),
      topic: (data) => TopicCover.medium(
        topic: data.topic.asPreview,
        onBookmarkTap: onRemoveBookmarkCallback,
        onTap: () => context.pushRoute(
          TopicPage(
            topicSlug: data.topic.slug,
            openedFrom: context.l10n.main_savedTab,
          ),
        ),
      ),
      unknown: (_) => const SizedBox.shrink(),
    );
  }
}
