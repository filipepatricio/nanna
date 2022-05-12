import 'package:better_informed_mobile/domain/search/data/search_content.dart';

abstract class SearchRepository {
  Future<SearchContent> searchContent(String query, int limit, int offset);
}
