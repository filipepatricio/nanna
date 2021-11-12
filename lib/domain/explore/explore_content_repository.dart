import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

abstract class ExploreContentRepository {
  Future<ExploreContent> getExploreContent();

  Future<List<MediaItemArticle>> getPaginatedArticles(String sectionId, int limit, int offset);

  Future<List<Topic>> getPaginatedTopics(String sectionId, int limit, int offset);
}
