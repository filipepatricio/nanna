import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_read_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/add_bookmark_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_change_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/remove_bookmark_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_page_loader.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_tile_cover.dt.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BookmarkListViewCubit extends Cubit<BookmarkListViewState> {
  BookmarkListViewCubit(
    this._bookmarkPaginationEngineProvider,
    this._getBookmarkChangeStreamUseCase,
    this._removeBookmarkUseCase,
    this._addBookmarkUseCase,
    this._trackActivityUseCase,
    this._getArticleReadProgressUseCase,
  ) : super(BookmarkListViewState.initial());

  final BookmarkPaginationEngineProvider _bookmarkPaginationEngineProvider;
  final GetBookmarkChangeStreamUseCase _getBookmarkChangeStreamUseCase;
  final RemoveBookmarkUseCase _removeBookmarkUseCase;
  final AddBookmarkUseCase _addBookmarkUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetArticleReadProgressUseCase _getArticleReadProgressUseCase;

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
        final filter = state.filter;
        final bookmarks = state.bookmarks;

        emit(BookmarkListViewState.loadMore(filter, bookmarks));

        final paginationState = await _paginationEngine.loadMore();
        _handlePaginationState(paginationState);
      },
    );
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    final bookmarks = state.bookmarks;
    final index = bookmarks.map((e) => e.bookmark).toList().indexOf(bookmark);
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
    _notifierSubscription = _getBookmarkChangeStreamUseCase()
        .debounceTime(const Duration(seconds: 1))
        .switchMap((changedData) => _reloadOnChangeNotification(changedData, filter, sort, order))
        .listen(_handlePaginationState);
  }

  Stream<PaginationEngineState<Bookmark>> _reloadOnChangeNotification(
    BookmarkTypeData changedData,
    BookmarkFilter filter,
    BookmarkSort sort,
    BookmarkOrder order,
  ) async* {
    final filters = [BookmarkFilter.all] +
        changedData.map(
          article: (_) => [BookmarkFilter.article],
          topic: (_) => [BookmarkFilter.topic],
        );

    if (filters.contains(filter)) {
      emit(BookmarkListViewState.loading(filter));
      yield await _initializePaginationEngine(filter, sort, order);
    }
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

  List<BookmarkTileCover> _getProcessedBookmarks(List<Bookmark> bookmarks) {
    return _processBookmarks(bookmarks).toList(growable: false);
  }

  Iterable<BookmarkTileCover> _processBookmarks(List<Bookmark> bookmarks) sync* {
    var topicIndex = 0;
    var articleIndex = 0;

    for (var i = 0; i < bookmarks.length; i++) {
      final bookmark = bookmarks[i];

      final cover = bookmark.data.mapOrNull(
        article: (data) {
          if (data.article.hasImage) {
            return BookmarkTileCover.standard(bookmark);
          } else {
            return BookmarkTileCover.dynamic(bookmark, articleIndex++);
          }
        },
        topic: (data) {
          return BookmarkTileCover.dynamic(bookmark, topicIndex++);
        },
      );

      if (cover != null) yield cover;
    }
  }

  ArticleProgress? getCurrentReadProgress(BookmarkData bookmarkData) {
    return bookmarkData.mapOrNull(
      article: (data) => data.article.progress.copyWith(
        contentProgress: _getArticleReadProgressUseCase(data.article),
      ),
    );
  }
}

extension on BookmarkListViewState {
  List<BookmarkTileCover> get bookmarks {
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
