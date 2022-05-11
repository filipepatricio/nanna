import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_result_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/search_api_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchApiDataSource, env: mockEnvs)
class SearchMockDataSource implements SearchApiDataSource {
  @override
  Future<SearchContentDTO> searchContent(String query, int limit, int offset) async {
    return MockDTO.search;
  }

  @override
  Future<List<SearchResultDTO>> searchPaginatedArticles(String query, int limit, int offset) {
    // TODO: implement searchPaginatedArticles
    throw UnimplementedError();
  }

  @override
  Future<List<SearchResultDTO>> searchPaginatedTopics(String query, int limit, int offset) {
    // TODO: implement searchPaginatedTopics
    throw UnimplementedError();
  }
}
