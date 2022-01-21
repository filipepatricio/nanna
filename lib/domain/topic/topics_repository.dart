import 'package:better_informed_mobile/domain/topic/data/topic.dart';

abstract class TopicsRepository {
  Future<List<Topic>> getTopicsFromExpert(String expertId);

  Future<Topic> getTopicBySlug(String slug);
}
