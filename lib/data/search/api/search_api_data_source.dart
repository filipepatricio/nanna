import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';

abstract class SearchApiDataSource {
  Future<SearchContentDTO> searchContent(String query, int limit, int offset);
}
