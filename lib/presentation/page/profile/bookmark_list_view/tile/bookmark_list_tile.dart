import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/types.dart';
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
    return Column(
      children: [
        const SizedBox(height: AppDimens.m),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.ml,
          ),
          child: bookmark.getContent(
            context,
            () => onRemoveBookmarkPressed(bookmark),
          ),
        ),
        const SizedBox(height: AppDimens.m),
      ],
    );
  }
}

extension on Bookmark {
  Widget getContent(
    BuildContext context,
    VoidCallback? onRemoveBookmarkCallback,
  ) {
    return data.map(
      article: (data) => ArticleCover.list(
        article: data.article,
        onTap: () => context.pushRoute(
          MediaItemPageRoute(article: data.article),
        ),
        onBookmarkTap: onRemoveBookmarkCallback,
      ),
      topic: (data) => TopicCover.big(
        topic: data.topic.asPreview,
        onBookmarkTap: onRemoveBookmarkCallback,
        onTap: () => context.pushRoute(
          TopicPage(topicSlug: data.topic.slug),
        ),
      ),
      unknown: (_) => const SizedBox.shrink(),
    );
  }
}
