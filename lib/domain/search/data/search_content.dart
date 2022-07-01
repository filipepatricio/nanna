import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';

class SearchContent {
  SearchContent({
    required this.results,
  });
  final List<SearchResult> results;
}
