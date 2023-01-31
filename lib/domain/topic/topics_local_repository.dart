import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

abstract class TopicsLocalRepository implements SynchronizableRepository<Topic> {
  Future<void> deleteAll();
}
