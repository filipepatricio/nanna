import 'package:better_informed_mobile/domain/result_item/result_item.dt.dart';
import 'package:better_informed_mobile/domain/search/search_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPaginatedSearchContentUseCase {
  final SearchRepository _searchRepository;

  GetPaginatedSearchContentUseCase(this._searchRepository);

  Future<List<ResultItem>> call({required String query, required int limit, required int offset}) async {
    final searchContent = await _searchRepository.searchContent(
      query,
      limit,
      offset,
    );
    return searchContent.results;
  }
}
