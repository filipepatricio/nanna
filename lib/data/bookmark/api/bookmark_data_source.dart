import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_filter_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_id_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_list_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_order_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_sort_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/update_bookmark_response_dto.dt.dart';

abstract class BookmarkDataSource {
  Future<BookmarkIdDTO?> getTopicBookmarkId(String topicSlug);

  Future<BookmarkIdDTO?> getArticleBookmarkId(String articleSlug);

  Future<UpdateBookmarkResponseDTO> bookmarkTopic(String topicSlug);

  Future<UpdateBookmarkResponseDTO> bookmarkArticle(String articleSlug);

  Future<UpdateBookmarkResponseDTO> removeBookmark(String bookmarkId);

  Future<BookmarkListDTO> getPaginatedBookmarks({
    required int limit,
    required int offset,
    required BookmarkFilterDTO filter,
    required BookmarkOrderDTO order,
    required BookmarkSortDTO sortBy,
  });
}
