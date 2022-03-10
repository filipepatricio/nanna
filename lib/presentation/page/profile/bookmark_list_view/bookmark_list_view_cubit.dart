import 'dart:async';

import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_change_stream_use_case.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_page_loader.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BookmarkListViewCubit extends Cubit<BookmarkListViewState> {
  BookmarkListViewCubit(
    this._bookmarkPaginationEngineProvider,
    this._getBookmarkChangeStreamUseCase,
  ) : super(BookmarkListViewState.initial());

  final BookmarkPaginationEngineProvider _bookmarkPaginationEngineProvider;
  final GetBookmarkChangeStreamUseCase _getBookmarkChangeStreamUseCase;

  late PaginationEngine<Bookmark> _paginationEngine;

  StreamSubscription? _notifierSubscription;

  @override
  Future<void> close() {
    _notifierSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(BookmarkFilter filter, BookmarkSort sort, BookmarkOrder order) async {
    emit(BookmarkListViewState.loading(filter));

    final paginationState = await _initializePaginationEngine(filter, sort, order);
    _handlePaginationState(paginationState);

    _registerBookmarkChangeNotification(filter, sort, order);
  }

  Future<void> loadNextPage() async {
    await state.mapOrNull(
      idle: (state) async {
        Fimber.d('Load more');
        final filter = state.filter;
        final bookmarks = state.bookmarks;

        emit(BookmarkListViewState.loadMore(filter, bookmarks));

        final paginationState = await _paginationEngine.loadMore();
        _handlePaginationState(paginationState);
      },
    );
  }

  void _registerBookmarkChangeNotification(BookmarkFilter filter, BookmarkSort sort, BookmarkOrder order) {
    _notifierSubscription = _getBookmarkChangeStreamUseCase(filter)
        .debounceTime(const Duration(seconds: 1))
        .switchMap((_) => _reloadOnChangeNotification(filter, sort, order))
        .listen(_handlePaginationState);
  }

  Stream<PaginationEngineState<Bookmark>> _reloadOnChangeNotification(
    BookmarkFilter filter,
    BookmarkSort sort,
    BookmarkOrder order,
  ) async* {
    emit(BookmarkListViewState.loading(filter));
    yield await _initializePaginationEngine(filter, sort, order);
  }

  Future<PaginationEngineState<Bookmark>> _initializePaginationEngine(
    BookmarkFilter filter,
    BookmarkSort sort,
    BookmarkOrder order,
  ) async {
    _paginationEngine = _bookmarkPaginationEngineProvider.get(
      filter: filter,
      sort: sort,
      order: order,
    );
    return _paginationEngine.loadMore();
  }

  void _handlePaginationState(PaginationEngineState<Bookmark> paginationState) {
    final filter = state.requireFilter;
    final bookmarks = paginationState.data;

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
