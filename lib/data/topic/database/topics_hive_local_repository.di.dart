import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/synchronziable_topic_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:hive/hive.dart';

const _boxName = 'topics';

class TopicsHiveLocalRepository implements TopicsLocalRepository {
  TopicsHiveLocalRepository._(this._topicBox, this._topicEntityMapper);

  static Future<TopicsHiveLocalRepository> create(SynchronizableTopicEntityMapper topicEntityMapper) async {
    final box = await Hive.openLazyBox<SynchronizableEntity<TopicEntity>>(_boxName);
    return TopicsHiveLocalRepository._(box, topicEntityMapper);
  }

  final SynchronizableTopicEntityMapper _topicEntityMapper;

  final LazyBox<SynchronizableEntity<TopicEntity>> _topicBox;

  @override
  Future<void> deleteAll() async {
    await _topicBox.clear();
  }

  @override
  Future<void> deleteTopic(String slug) async {
    await _topicBox.delete(slug);
  }

  @override
  Future<Synchronizable<Topic>?> loadTopic(String slug) async {
    final entity = await _topicBox.get(slug);
    return entity != null ? _topicEntityMapper.to(entity) : null;
  }

  @override
  Future<void> saveTopic(Synchronizable<Topic> topic) {
    final entity = _topicEntityMapper.from(topic);
    return _topicBox.put(topic.data.slug, entity);
  }
}
