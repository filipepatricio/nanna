import 'package:better_informed_mobile/data/bookmark/api/bookmark_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_filter_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_id_to_state_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_order_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/mapper/bookmark_sort_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BookmarkRepository)
class BookmarkApiRepository implements BookmarkRepository {
  BookmarkApiRepository(
    this._bookmarkDataSource,
    this._bookmarkIdToStateMapper,
    this._bookmarkFilterDTOMapper,
    this._bookmarkOrderDTOMapper,
    this._bookmarkSortDTOMapper,
    this._bookmarkDTOMapper,
  );

  final BookmarkDataSource _bookmarkDataSource;
  final BookmarkIdToStateMapper _bookmarkIdToStateMapper;
  final BookmarkFilterDTOMapper _bookmarkFilterDTOMapper;
  final BookmarkOrderDTOMapper _bookmarkOrderDTOMapper;
  final BookmarkSortDTOMapper _bookmarkSortDTOMapper;
  final BookmarkDTOMapper _bookmarkDTOMapper;

  @override
  Future<BookmarkState> getArticleBookmarkState(String articleSlug) async {
    final dto = await _bookmarkDataSource.getArticleBookmarkId(articleSlug);
    return _bookmarkIdToStateMapper(dto);
  }

  @override
  Future<BookmarkState> getTopicBookmarkState(String topicSlug) async {
    final dto = await _bookmarkDataSource.getTopicBookmarkId(topicSlug);
    return _bookmarkIdToStateMapper(dto);
  }

  @override
  Future<BookmarkState> bookmarkArticle(String articleSlug) async {
    final dto = await _bookmarkDataSource.bookmarkArticle(articleSlug);
    return _bookmarkIdToStateMapper(dto.bookmark);
  }

  @override
  Future<BookmarkState> bookmarkTopic(String topicSlug) async {
    final dto = await _bookmarkDataSource.bookmarkTopic(topicSlug);
    return _bookmarkIdToStateMapper(dto.bookmark);
  }

  @override
  Future<BookmarkState> removeBookmark(String bookmarkId) async {
    final dto = await _bookmarkDataSource.removeBookmark(bookmarkId);

    if (dto.successful) {
      return BookmarkState.notBookmarked();
    }

    return BookmarkState.bookmarked(bookmarkId);
  }

  @override
  Future<List<Bookmark>> getPaginatedBookmarks({
    required int limit,
    required int offset,
    required BookmarkFilter filter,
    required BookmarkOrder order,
    required BookmarkSort sort,
  }) async {
    final dto = await _bookmarkDataSource.getPaginatedBookmarks(
      limit: limit,
      offset: offset,
      filter: _bookmarkFilterDTOMapper(filter),
      order: _bookmarkOrderDTOMapper(order),
      sortBy: _bookmarkSortDTOMapper(sort),
    );

    return dto.bookmarks
        .map((bookmarkDto) => _bookmarkDTOMapper(bookmarkDto))
        .where((bookmark) => bookmark.isValid)
        .toList();
  }
}

extension on Bookmark {
  bool get isValid => data.maybeMap(orElse: () => true, unknown: (_) => false);
}
