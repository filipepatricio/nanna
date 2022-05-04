import 'package:better_informed_mobile/domain/search/data/search_content.dart';
import 'package:better_informed_mobile/domain/search/search_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchContentUseCase {
  final SearchRepository _searchRepository;

  SearchContentUseCase(this._searchRepository);

  Future<SearchContent> call(String query, int limit, int offset) async {
    final searchContent = await _searchRepository.searchContent(query, limit, offset);
    return searchContent;
  }
}
