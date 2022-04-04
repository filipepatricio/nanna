import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPaginatedBookmarksUseCase {
  GetPaginatedBookmarksUseCase(this._bookmarkRepository);

  final BookmarkRepository _bookmarkRepository;

  Future<List<Bookmark>> call({
    required int limit,
    required int offset,
    required BookmarkFilter filter,
    required BookmarkOrder order,
    required BookmarkSort sort,
  }) {
    return _bookmarkRepository.getPaginatedBookmarks(
      limit: limit,
      offset: offset,
      filter: filter,
      order: order,
      sort: sort,
    );
  }
}
