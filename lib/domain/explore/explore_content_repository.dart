import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

abstract class ExploreContentRepository {
  Future<ExploreContent> getExploreContent();

  Future<List<MediaItemArticle>> getPaginatedArticles(String areaId, int limit, int offset);

  Future<List<Topic>> getPaginatedTopics(String areaId, int limit, int offset);
}
