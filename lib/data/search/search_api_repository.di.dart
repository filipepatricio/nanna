import 'package:better_informed_mobile/data/search/api/mapper/search_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/search/api/search_api_data_source.dart';
import 'package:better_informed_mobile/domain/search/data/search_content.dart';
import 'package:better_informed_mobile/domain/search/search_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchRepository)
class SearchApiRepository implements SearchRepository {
  final SearchApiDataSource _dataSource;
  final SearchContentDTOMapper _searchContentDTOMapper;

  SearchApiRepository(
    this._dataSource,
    this._searchContentDTOMapper,
  );

  @override
  Future<SearchContent> searchContent(String query, int limit, int offset) async {
    final dto = await _dataSource.searchContent(query, limit, offset);
    return _searchContentDTOMapper(dto);
  }
}
