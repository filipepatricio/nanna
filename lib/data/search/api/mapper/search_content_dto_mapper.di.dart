import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/result_item/mapper/result_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';
import 'package:better_informed_mobile/domain/general/result_item.dt.dart';
import 'package:better_informed_mobile/domain/search/data/search_content.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchContentDTOMapper implements Mapper<SearchContentDTO, SearchContent> {
  final ResultItemDTOMapper _resultItemDTOMapper;

  SearchContentDTOMapper(
    this._resultItemDTOMapper,
  );

  @override
  SearchContent call(SearchContentDTO data) {
    return SearchContent(
      results: data.search.map<ResultItem>(_resultItemDTOMapper).toList(),
    );
  }
}
