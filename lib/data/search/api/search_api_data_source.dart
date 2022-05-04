import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_result_dto.dt.dart';

abstract class SearchApiDataSource {
  Future<SearchContentDTO> searchContent(String query, int limit, int offset);

  Future<List<SearchResultDTO>> searchPaginatedArticles(String query, int limit, int offset);

  Future<List<SearchResultDTO>> searchPaginatedTopics(String query, int limit, int offset);
}
