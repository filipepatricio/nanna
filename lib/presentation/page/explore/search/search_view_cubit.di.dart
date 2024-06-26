import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/domain/search/use_case/add_search_history_query_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_loader.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

const _minSearchQueryCharactersTrigger = 2;

@injectable
class SearchViewCubit extends Cubit<SearchViewState> {
  SearchViewCubit(
    this._searchPaginationEngineProvider,
    this._addSearchHistoryQueryUseCase,
    this._trackActivityUseCase,
    this._isGuestModeUseCase,
  ) : super(SearchViewState.initial());

  final IsGuestModeUseCase _isGuestModeUseCase;
  final AddSearchHistoryQueryUseCase _addSearchHistoryQueryUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final SearchPaginationEngineProvider _searchPaginationEngineProvider;
  late PaginationEngine<SearchResult> _paginationEngine;
  late String _query;

  StreamController<String>? _queryStreamController;
  StreamController? _nextPageStreamController = StreamController.broadcast();
  StreamSubscription? _querySubscription;
  StreamSubscription? _nextPageSubscription;

  Future<void> initialize() async {
    if (await _isGuestModeUseCase()) {
      emit(SearchViewState.guest());
      return;
    }

    await _initializeQueryController();
  }

  @override
  Future<void> close() async {
    await _querySubscription?.cancel();
    await _nextPageSubscription?.cancel();
    await _queryStreamController?.close();
    await _nextPageStreamController?.close();
    return super.close();
  }

  Future<void> search(String query) async {
    _query = query.trim();
    _queryStreamController?.add(_query);
  }

  Future<void> submitSearchPhrase(String query) async {
    await _addSearchHistoryQueryUseCase(query);
  }

  Future<void> refresh() async {
    await _initializeQueryController();
    await search(_query);
  }

  Future<void> loadNextPage() async {
    _nextPageStreamController?.add(null);
  }

  Future<void> _initializeQueryController() async {
    await _querySubscription?.cancel();
    await _queryStreamController?.close();
    _queryStreamController = StreamController.broadcast();
    _querySubscription = _queryStreamController?.stream
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .where((query) => shouldTriggerSearch(query))
        .switchMap((value) => Stream.fromFuture(_initializePaginationEngine(value)))
        .listen((event) => _onQueryChange(event));
  }

  Future<PaginationEngineState<SearchResult>> _initializePaginationEngine(
    String query,
  ) async {
    emit(SearchViewState.loading());
    _trackActivityUseCase.trackEvent(AnalyticsEvent.searched(query: _query));
    _paginationEngine = _searchPaginationEngineProvider.get(
      query: query,
    );
    return _paginationEngine.loadMore();
  }

  void _onQueryChange(PaginationEngineState<SearchResult> event) {
    _nextPageSubscription?.cancel();
    _nextPageStreamController?.close();
    _nextPageStreamController = StreamController.broadcast();
    _nextPageSubscription = _nextPageStreamController?.stream
        .asyncMap((_) => _loadNextPage())
        .listen((event) => _handlePaginationState(event));

    _handlePaginationState(event);
  }

  Future<PaginationEngineState<SearchResult>?> _loadNextPage() async {
    return state.maybeMap(
      idle: (state) async {
        final results = state.results;

        emit(SearchViewState.loadMore(results));

        return _paginationEngine.loadMore();
      },
      orElse: () => null,
    );
  }

  void _handlePaginationState(PaginationEngineState<SearchResult>? paginationState) {
    if (paginationState == null || isClosed) return;

    final results = paginationState.data;

    if (results.isEmpty) {
      emit(SearchViewState.empty(_query));
    } else if (paginationState.allLoaded) {
      emit(SearchViewState.allLoaded(results));
    } else {
      emit(SearchViewState.idle(results));
    }
  }

  bool shouldTriggerSearch(String query) {
    return query.isNotEmpty && query.length >= _minSearchQueryCharactersTrigger;
  }
}
