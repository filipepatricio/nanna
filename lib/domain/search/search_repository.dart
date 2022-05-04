import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/search/data/search_content.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';

abstract class SearchRepository {
  Future<SearchContent> searchContent(String query, int limit, int offset);

  Future<List<MediaItemArticle>> searchPaginatedArticles(String query, int limit, int offset);

  Future<List<TopicPreview>> searchPaginatedTopics(String query, int limit, int offset);
}
