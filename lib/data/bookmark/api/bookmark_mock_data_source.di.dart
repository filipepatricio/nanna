import 'package:better_informed_mobile/data/bookmark/api/bookmark_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_filter_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_id_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_list_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_order_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_sort_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/update_bookmark_response_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BookmarkDataSource, env: mockEnvs)
class BookmarkMockDataSource implements BookmarkDataSource {
  @override
  Future<BookmarkIdDTO> getArticleBookmarkId(String articleSlug) async {
    return BookmarkIdDTO('0000');
  }

  @override
  Future<BookmarkIdDTO> getTopicBookmarkId(String topicSlug) async {
    return BookmarkIdDTO('0000');
  }

  @override
  Future<UpdateBookmarkResponseDTO> bookmarkArticle(String articleSlug) async {
    return UpdateBookmarkResponseDTO(
      true,
      BookmarkIdDTO('0000'),
    );
  }

  @override
  Future<UpdateBookmarkResponseDTO> bookmarkTopic(String topicSlug) async {
    return UpdateBookmarkResponseDTO(
      true,
      BookmarkIdDTO('0000'),
    );
  }

  @override
  Future<UpdateBookmarkResponseDTO> removeBookmark(String bookmarkId) async {
    return UpdateBookmarkResponseDTO(
      true,
      BookmarkIdDTO('0000'),
    );
  }

  @override
  Future<BookmarkListDTO> getPaginatedBookmarks({
    required int limit,
    required int offset,
    required BookmarkFilterDTO filter,
    required BookmarkOrderDTO order,
    required BookmarkSortDTO sortBy,
  }) async {
    return MockDTO.bookmarkList;
  }
}
