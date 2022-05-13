import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_loader.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/debouncer.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchViewCubit extends Cubit<SearchViewState> {
  final SearchPaginationEngineProvider _searchPaginationEngineProvider;
  late PaginationEngine<SearchResult> _paginationEngine;
  late String _query;

  final _debouncer = Debouncer(milliseconds: 500);

  SearchViewCubit(
    this._searchPaginationEngineProvider,
  ) : super(SearchViewState.initial());

  Future<void> initialize() async {
    emit(SearchViewState.initial());
  }

  Future<void> search(String query) async {
    _query = query;
    if (query.isEmpty) {
      emit(SearchViewState.initial());
      return;
    }

    final paginationState = await _initializePaginationEngine(query);
    _debouncer.run(() => _handlePaginationState(paginationState));
  }

  Future<void> refresh() async {
    await search(_query);
  }

  Future<PaginationEngineState<SearchResult>> _initializePaginationEngine(
    String query,
  ) async {
    emit(SearchViewState.loading());
    _paginationEngine = _searchPaginationEngineProvider.get(
      query: query,
    );
    return _paginationEngine.loadMore();
  }

  Future<void> loadNextPage() async {
    await state.mapOrNull(
      idle: (state) async {
        final results = state.results;

        emit(SearchViewState.loadMore(results));

        final paginationState = await _paginationEngine.loadMore();
        _handlePaginationState(paginationState);
      },
    );
  }

  void _handlePaginationState(PaginationEngineState<SearchResult> paginationState) {
    if (isClosed) return;

    final results = paginationState.data;

    if (results.isEmpty) {
      emit(SearchViewState.empty(_query));
    } else if (paginationState.allLoaded) {
      emit(SearchViewState.allLoaded(results));
    } else {
      emit(SearchViewState.idle(results));
    }
  }
}
