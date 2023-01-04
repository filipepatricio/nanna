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
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/get_should_update_article_progress_state_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_page_loader.di.dart';
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
    this._removeBookmarkUseCase,
    this._addBookmarkUseCase,
    this._trackActivityUseCase,
    this._getShouldUpdateArticleProgressStateUseCase,
  ) : super(BookmarkListViewState.initial());

  final BookmarkPaginationEngineProvider _bookmarkPaginationEngineProvider;
  final GetBookmarkChangeStreamUseCase _getBookmarkChangeStreamUseCase;
  final RemoveBookmarkUseCase _removeBookmarkUseCase;
  final AddBookmarkUseCase _addBookmarkUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetShouldUpdateArticleProgressStateUseCase _getShouldUpdateArticleProgressStateUseCase;

  late PaginationEngine<Bookmark> _paginationEngine;

  StreamSubscription? _bookmarkChangeNotifierSubscription;
  StreamSubscription? _shouldUpdateArticleProgressStateSubscription;

  @override
  Future<void> close() {
    _bookmarkChangeNotifierSubscription?.cancel();
    _shouldUpdateArticleProgressStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(BookmarkFilter filter, BookmarkSort sort, BookmarkOrder order) async {
    emit(BookmarkListViewState.loading(filter));

    try {
      final paginationState = await _initializePaginationEngine(filter, sort, order);
      _handlePaginationState(paginationState);
    } catch (e, s) {
      Fimber.e('Loading bookmark list failed', ex: e, stacktrace: s);
      emit(BookmarkListViewState.error());
    }

    _registerBookmarkChangeNotification(filter, sort, order);

    _shouldUpdateArticleProgressStateSubscription =
        _getShouldUpdateArticleProgressStateUseCase().listen((updatedArticle) {
      state.mapOrNull(
        idle: (state) {
          final updatedResults = updateBookmarks(state.bookmarks, updatedArticle);
          emit(state.copyWith(bookmarks: updatedResults));
        },
        loadMore: (state) {
          final updatedResults = updateBookmarks(state.bookmarks, updatedArticle);
          emit(state.copyWith(bookmarks: updatedResults));
        },
        allLoaded: (state) {
          final updatedResults = updateBookmarks(state.bookmarks, updatedArticle);
          emit(state.copyWith(bookmarks: updatedResults));
        },
      );
    });
  }

  List<Bookmark> updateBookmarks(List<Bookmark> bookmarks, MediaItemArticle updatedArticle) {
    return bookmarks.map((element) {
      final updatedData = element.data.mapOrNull(
        article: (result) {
          if (result.article.id == updatedArticle.id) {
            return result.copyWith(article: updatedArticle);
          }
        },
      );
      return element.copyWith(data: updatedData);
    }).toList();
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
