import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/add_bookmark_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_change_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/remove_bookmark_use_case.di.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/saved/bookmark_list_view/bookmark_list_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/saved/bookmark_list_view/bookmark_page_loader.di.dart';
import 'package:better_informed_mobile/presentation/util/connection_state_aware_cubit_mixin.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BookmarkListViewCubit extends Cubit<BookmarkListViewState>
    with ConnectionStateAwareCubitMixin<BookmarkListViewState, BookmarkListOptions> {
  BookmarkListViewCubit(
    this._bookmarkPaginationEngineProvider,
    this._getBookmarkChangeStreamUseCase,
    this._removeBookmarkUseCase,
    this._addBookmarkUseCase,
    this._trackActivityUseCase,
    this._isInternetConnectionAvailableUseCase,
  ) : super(BookmarkListViewState.initial());

  final BookmarkPaginationEngineProvider _bookmarkPaginationEngineProvider;
  final GetBookmarkChangeStreamUseCase _getBookmarkChangeStreamUseCase;
  final RemoveBookmarkUseCase _removeBookmarkUseCase;
  final AddBookmarkUseCase _addBookmarkUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  late PaginationEngine<Bookmark> _paginationEngine;

  StreamSubscription? _bookmarkChangeNotifierSubscription;

  @override
  Future<void> close() {
    _bookmarkChangeNotifierSubscription?.cancel();
    return super.close();
  }

  @override
  IsInternetConnectionAvailableUseCase get isInternetConnectionAvailableUseCase =>
      _isInternetConnectionAvailableUseCase;

  @override
  Future<void> onOffline(BookmarkListOptions initialData) async {
    await _freshInitialization(initialData, false);
  }

  @override
  Future<void> onOnline(BookmarkListOptions initialData) async {
    await _freshInitialization(initialData, true);
  }

  Future<void> initialize(BookmarkFilter filter, BookmarkSort sort, BookmarkOrder order) async {
    final options = BookmarkListOptions(filter, sort, order);
    await initializeConnection(options);

    _registerBookmarkChangeNotification(filter, sort, order);
  }

  Future<void> loadNextPage() async {
    await state.mapOrNull(
      idle: (state) async {
        final filter = state.filter;
        final bookmarks = state.bookmarks;

        emit(BookmarkListViewState.loadMore(filter, bookmarks));

        try {
          final paginationState = await _paginationEngine.loadMore();
          _handlePaginationState(paginationState);
        } catch (e, s) {
          Fimber.e('Loading bookmark list failed', ex: e, stacktrace: s);
          emit(BookmarkListViewState.error());
        }
      },
    );
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    final bookmarks = state.bookmarks;
    final index = bookmarks.indexOf(bookmark);

    if (index != -1) {
      final updatedList = _paginationEngine.removeItemAt(index);

      final newState = state.mapOrNull(
        idle: (state) {
          if (updatedList.isEmpty) {
            return BookmarkListViewState.empty(state.filter);
          }
          return state.copyWith(bookmarks: _getProcessedBookmarks(updatedList));
        },
        loadMore: (state) {
          if (updatedList.isEmpty) {
            return BookmarkListViewState.loading(state.filter);
          }
          return state.copyWith(bookmarks: _getProcessedBookmarks(updatedList));
        },
        allLoaded: (state) {
          if (updatedList.isEmpty) {
            return BookmarkListViewState.empty(state.filter);
          }
          return state.copyWith(bookmarks: _getProcessedBookmarks(updatedList));
        },
      );

      if (newState != null) {
        emit(newState);
        await _removeBookmarkUseCase(bookmark);
        final currentState = state;

        if (isClosed) return;

        emit(BookmarkListViewState.bookmarkRemoved(bookmark, index));
        emit(currentState);
      }
    }
  }

  Future<void> undoRemovingBookmark(Bookmark bookmark, int index) async {
    _trackBookmarkRemoveUndo(bookmark);

    final bookmarkState = await _addBookmarkUseCase(bookmark);

    if (isClosed) return;

    bookmarkState?.mapOrNull(
      bookmarked: (value) {
        final newBookmark = Bookmark(value.id, bookmark.data);
        final updatedList = _paginationEngine.insert(newBookmark, index);
        final newState = state.mapOrNull(
          idle: (state) => state.copyWith(bookmarks: _getProcessedBookmarks(updatedList)),
          loadMore: (state) => state.copyWith(bookmarks: _getProcessedBookmarks(updatedList)),
          allLoaded: (state) => state.copyWith(bookmarks: _getProcessedBookmarks(updatedList)),
        );

        if (newState != null) {
          emit(newState);
        }
      },
    );
  }

  Future<void> _freshInitialization(BookmarkListOptions initialData, bool remote) async {
    emit(BookmarkListViewState.loading(initialData.filter));

    try {
      final paginationState = await _initializePaginationEngine(
        initialData.filter,
        initialData.sort,
        initialData.order,
        remote,
      );
      _handlePaginationState(paginationState);
    } catch (e, s) {
      Fimber.e('Loading bookmark list while offline failed', ex: e, stacktrace: s);
      emit(BookmarkListViewState.error());
    }
  }

  void _trackBookmarkRemoveUndo(Bookmark bookmark) {
    bookmark.data.mapOrNull(
      article: (value) => _trackActivityUseCase.trackEvent(
        AnalyticsEvent.articleBookmarkRemoveUndo(value.article.id),
      ),
      topic: (value) => _trackActivityUseCase.trackEvent(
        AnalyticsEvent.topicBookmarkRemoveUndo(value.topic.id),
      ),
    );
  }

  void _registerBookmarkChangeNotification(BookmarkFilter filter, BookmarkSort sort, BookmarkOrder order) {
    _bookmarkChangeNotifierSubscription = _getBookmarkChangeStreamUseCase()
        .debounceTime(const Duration(seconds: 1))
        .switchMap((event) => _reloadOnChangeNotification(event, filter, sort, order))
        .listen(_handlePaginationState);
  }

  Stream<PaginationEngineState<Bookmark>> _reloadOnChangeNotification(
    BookmarkEvent event,
    BookmarkFilter filter,
    BookmarkSort sort,
    BookmarkOrder order,
  ) async* {
    final filters = [BookmarkFilter.all] +
        event.data.map(
          article: (_) => [BookmarkFilter.article],
          topic: (_) => [BookmarkFilter.topic],
        );

    if (filters.contains(filter)) {
      emit(BookmarkListViewState.loading(filter));
      final isOnline = isCurrentlyOnline ?? true;
      yield await _initializePaginationEngine(
        filter,
        sort,
        order,
        isOnline,
      );
    }
  }

  Future<PaginationEngineState<Bookmark>> _initializePaginationEngine(
    BookmarkFilter filter,
    BookmarkSort sort,
    BookmarkOrder order,
    bool remote,
  ) async {
    _paginationEngine = _bookmarkPaginationEngineProvider.get(
      filter: filter,
      sort: sort,
      order: order,
      remote: remote,
    );

    return _paginationEngine.loadMore();
  }

  void _handlePaginationState(PaginationEngineState<Bookmark> paginationState) {
    if (isClosed) return;

    final filter = state.requireFilter;
    final bookmarks = paginationState.data;

    if (bookmarks.isEmpty) {
      emit(BookmarkListViewState.empty(filter));
    } else if (paginationState.allLoaded) {
      emit(BookmarkListViewState.allLoaded(filter, _getProcessedBookmarks(bookmarks)));
    } else {
      emit(BookmarkListViewState.idle(filter, _getProcessedBookmarks(bookmarks)));
    }
  }

  List<Bookmark> _getProcessedBookmarks(List<Bookmark> bookmarks) {
    return _processBookmarks(bookmarks).toList(growable: false);
  }

  Iterable<Bookmark> _processBookmarks(List<Bookmark> bookmarks) sync* {
    for (final bookmark in bookmarks) {
      final cover = bookmark.data.mapOrNull(
        article: (data) => bookmark,
        topic: (data) => bookmark,
      );

      if (cover != null) yield cover;
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
    return maybeMap(
      loading: (state) => state.filter,
      empty: (state) => state.filter,
      idle: (state) => state.filter,
      loadMore: (state) => state.filter,
      allLoaded: (state) => state.filter,
      orElse: () => throw Exception('Can not resolve filter at this state'),
    );
  }
}

class BookmarkListOptions {
  BookmarkListOptions(this.filter, this.sort, this.order);

  final BookmarkFilter filter;
  final BookmarkSort sort;
  final BookmarkOrder order;
}
