import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/bookmark/api/bookmark_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_data_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_filter_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_id_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_list_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_order_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_sort_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/update_bookmark_response_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dart';
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
    return BookmarkListDTO(
      [
        BookmarkDTO(
          '0000',
          BookmarkDataDTO.article(
            ArticleDTO(
              '',
              '',
              '',
              null,
              'Are We Entering a New Cold War?',
              'Are We Entering a New Cold War?',
              'credits',
              'PREMIUM',
              null,
              10,
              '',
              ImageDTO(''),
              PublisherDTO('New York Times', null, null),
              'David J',
            ),
          ),
        ),
        BookmarkDTO(
          '0000',
          BookmarkDataDTO.topic(
            TopicDTO(
              '',
              '',
              'Are We Entering a New Cold War?',
              'Are We Entering a New Cold War?',
              '',
              '',
              TopicOwnerDTO.editor('Editor', null),
              '2011-10-05T14:48:00.000Z',
              [],
              ImageDTO(''),
              ImageDTO(''),
              ReadingListDTO('', []),
              [],
            ),
          ),
        ),
      ],
    );
  }
}
