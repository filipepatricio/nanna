import 'package:better_informed_mobile/domain/general/result_item.dt.dart';
import 'package:better_informed_mobile/domain/search/use_case/search_content_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:injectable/injectable.dart';

class SearchViewLoader implements NextPageLoader<ResultItem> {
  SearchViewLoader(
    this._searchContentUseCase, {
    required this.query,
  });

  final GetPaginatedSearchContentUseCase _searchContentUseCase;
  final String query;

  @override
  Future<List<ResultItem>> call(NextPageConfig config) {
    return _searchContentUseCase(
      query: query,
      limit: config.limit,
      offset: config.offset,
    );
  }
}

@injectable
class SearchPaginationEngineProvider {
  SearchPaginationEngineProvider(this._searchContentUseCase);

  final GetPaginatedSearchContentUseCase _searchContentUseCase;

  PaginationEngine<ResultItem> get({required String query}) {
    final nextPageLoader = SearchViewLoader(
      _searchContentUseCase,
      query: query,
    );

    return PaginationEngine(nextPageLoader);
  }
}
