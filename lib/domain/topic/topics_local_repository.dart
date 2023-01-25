import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

abstract class TopicsLocalRepository {
  Future<Synchronizable<Topic>?> loadTopic(String slug);

  Future<void> saveTopic(Synchronizable<Topic> topic);

  Future<void> deleteTopic(String slug);

  Future<void> deleteAll();
}
