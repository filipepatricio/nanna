import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/presentation/page/search/search_page_loader.di.dart';
import 'package:better_informed_mobile/presentation/page/search/search_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/debouncer.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchPageCubit extends Cubit<SearchPageState> {
  final SearchPaginationEngineProvider _searchPaginationEngineProvider;
  late PaginationEngine<SearchResult> _paginationEngine;
  late String _query;

  final _debouncer = Debouncer(milliseconds: 300);

  SearchPageCubit(
    this._searchPaginationEngineProvider,
  ) : super(SearchPageState.initial());

  Future<void> initialize() async {
    emit(SearchPageState.initial());
  }

  Future<void> search(String query) async {
    _query = query;
    if (query.length < 3) {
      emit(SearchPageState.initial());
      return;
    }

    final paginationState = await _initializePaginationEngine(query);
    _debouncer.run(() => _handlePaginationState(paginationState));
  }

  Future<PaginationEngineState<SearchResult>> _initializePaginationEngine(
    String query,
  ) async {
    emit(SearchPageState.loading());
    _paginationEngine = _searchPaginationEngineProvider.get(
      query: query,
    );
    return _paginationEngine.loadMore();
  }

  Future<void> loadNextPage() async {
    await state.mapOrNull(
      idle: (state) async {
        final results = state.results;

        emit(SearchPageState.loadMore(results));

        final paginationState = await _paginationEngine.loadMore();
        _handlePaginationState(paginationState);
      },
    );
  }

  void _handlePaginationState(PaginationEngineState<SearchResult> paginationState) {
    if (isClosed) return;

    final results = paginationState.data;

    if (results.isEmpty) {
      emit(SearchPageState.empty(_query));
    } else if (paginationState.allLoaded) {
      emit(SearchPageState.allLoaded(results));
    } else {
      emit(SearchPageState.idle(results));
    }
  }
}
