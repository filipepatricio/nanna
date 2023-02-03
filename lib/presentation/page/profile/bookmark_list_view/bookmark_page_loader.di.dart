import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_paginated_bookmarks_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:injectable/injectable.dart';

class BookmarkPageLoader implements NextPageLoader<Bookmark> {
  BookmarkPageLoader(
    this._getPaginatedBookmarksUseCase, {
    required this.filter,
    required this.sort,
    required this.order,
    required this.remote,
  });

  final BookmarkFilter filter;
  final BookmarkSort sort;
  final BookmarkOrder order;
  final bool remote;
  final GetPaginatedBookmarksUseCase _getPaginatedBookmarksUseCase;

  @override
  Future<List<Bookmark>> call(NextPageConfig config) {
    return _getPaginatedBookmarksUseCase(
      limit: config.limit,
      offset: config.offset,
      filter: filter,
      sort: sort,
      order: order,
      remote: remote,
    );
  }
}

@injectable
class BookmarkPaginationEngineProvider {
  BookmarkPaginationEngineProvider(this._getPaginatedBookmarksUseCase);

  final GetPaginatedBookmarksUseCase _getPaginatedBookmarksUseCase;

  PaginationEngine<Bookmark> get({
    required BookmarkFilter filter,
    required BookmarkSort sort,
    required BookmarkOrder order,
    required bool remote,
  }) {
    final nextPageLoader = BookmarkPageLoader(
      _getPaginatedBookmarksUseCase,
      filter: filter,
      sort: sort,
      order: order,
      remote: remote,
    );

    return PaginationEngine(nextPageLoader);
  }
}
