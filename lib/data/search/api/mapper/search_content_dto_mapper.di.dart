import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/mapper/search_result_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/search/data/search_content.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchContentDTOMapper implements Mapper<SearchContentDTO, SearchContent> {
  final SearchResultDTOMapper _searchResultDTOMapper;

  SearchContentDTOMapper(
    this._searchResultDTOMapper,
  );

  @override
  SearchContent call(SearchContentDTO data) {
    return SearchContent(
      results: data.search.map<SearchResult>(_searchResultDTOMapper).toList(),
    );
  }
}
