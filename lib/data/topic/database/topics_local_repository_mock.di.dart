import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:injectable/injectable.dart';

// @LazySingleton(as: TopicsLocalRepository, env: mockEnvs)
@LazySingleton(as: TopicsLocalRepository)
class TopicsLocalRepositoryMock implements TopicsLocalRepository {
  @override
  Future<void> deleteAll() async {}

  @override
  Future<void> deleteTopic(String slug) async {}

  @override
  Future<Synchronizable<Topic>?> loadTopic(String slug) async {
    return null;
  }

  @override
  Future<void> saveTopic(Synchronizable<Topic> topic) async {}
}
