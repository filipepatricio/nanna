import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/filter_bookmarks_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPaginatedBookmarksUseCase {
  GetPaginatedBookmarksUseCase(
    this._bookmarkRepository,
    this._bookmarkLocalRepository,
    this._filterBookmarksUseCase,
  );

  final BookmarkRepository _bookmarkRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final FilterBookmarksUseCase _filterBookmarksUseCase;

  Future<List<Bookmark>> call({
    required int limit,
    required int offset,
    required BookmarkFilter filter,
    required BookmarkOrder order,
    required BookmarkSort sort,
    bool remote = true,
  }) async {
    if (remote) {
      return _bookmarkRepository.getPaginatedBookmarks(
        limit: limit,
        offset: offset,
        filter: filter,
        order: order,
        sort: sort,
      );
    } else {
      final bookmarks = await _bookmarkLocalRepository.getAllBookmarks();
      return _filterBookmarksUseCase(
        bookmarks,
        filter,
        sort,
        order,
      );
    }
  }
}
