import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/synchronization/database/mapper/synchronziable_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/database/entity/synchronizable_topic_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/topic_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizableTopicEntityMapper extends SynchronizableEntityMapper<TopicEntity, Topic> {
  SynchronizableTopicEntityMapper(TopicEntityMapper topicEntityMapper) : super(topicEntityMapper);

  @override
  SynchronizableEntity<TopicEntity> createEntity({
    required TopicEntity? data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  }) {
    return SynchronizableTopicEntity(
      dataId: dataId,
      data: data,
      createdAt: createdAt,
      synchronizedAt: synchronizedAt,
      expirationDate: expirationDate,
    );
  }
}
