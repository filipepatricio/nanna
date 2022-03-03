import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dart';

abstract class BookmarkRepository {
  Future<BookmarkState> getTopicBookmarkState(String topicSlug);

  Future<BookmarkState> getArticleBookmarkState(String articleSlug);

  Future<BookmarkState> bookmarkTopic(String topicSlug);

  Future<BookmarkState> bookmarkArticle(String articleSlug);

  Future<BookmarkState> removeBookmark(String bookmarkId);

  Future<List<Bookmark>> getPaginatedBookmarks({
    required int limit,
    required int offset,
    required BookmarkFilter filter,
    required BookmarkOrder order,
    required BookmarkSort sort,
  });
}
