import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_page_loader.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkListViewCubit extends Cubit<BookmarkListViewState> {
  BookmarkListViewCubit(
    this._bookmarkPaginationEngineProvider,
  ) : super(BookmarkListViewState.initial());

  final BookmarkPaginationEngineProvider _bookmarkPaginationEngineProvider;
  late PaginationEngine<Bookmark> _paginationEngine;

  Future<void> initialize(BookmarkFilter filter, BookmarkSort sort, BookmarkOrder order) async {
    emit(BookmarkListViewState.loading(filter));

    _paginationEngine = _bookmarkPaginationEngineProvider.get(
      filter: filter,
      sort: sort,
      order: order,
    );

    _paginationEngine.initialize([]);

    final paginationState = await _paginationEngine.loadMore();
    _handlePaginationState(paginationState);
  }

  Future<void> loadNextPage() async {
    final filter = state.requireFilter;
    final bookmarks = state.bookmarks;

    emit(BookmarkListViewState.loadMore(filter, bookmarks));

    final paginationState = await _paginationEngine.loadMore();
    _handlePaginationState(paginationState);
  }

  void _handlePaginationState(PaginationEngineState<Bookmark> paginationState) {
    final filter = state.requireFilter;
    final bookmarks = state.bookmarks + paginationState.data;

    if (bookmarks.isEmpty) {
      emit(BookmarkListViewState.empty(filter));
    } else if (paginationState.allLoaded) {
      emit(BookmarkListViewState.allLoaded(filter, bookmarks));
    } else {
      emit(BookmarkListViewState.idle(filter, bookmarks));
    }
  }
}

extension on BookmarkListViewState {
  List<Bookmark> get bookmarks {
    return maybeMap(
      idle: (state) => state.bookmarks,
      loadMore: (state) => state.bookmarks,
      allLoaded: (state) => state.bookmarks,
      orElse: () => [],
    );
  }

  BookmarkFilter get requireFilter {
    return map(
      initial: (state) => throw Exception('Can not resolve filter on initial state'),
      loading: (state) => state.filter,
      empty: (state) => state.filter,
      idle: (state) => state.filter,
      loadMore: (state) => state.filter,
      allLoaded: (state) => state.filter,
    );
  }
}
