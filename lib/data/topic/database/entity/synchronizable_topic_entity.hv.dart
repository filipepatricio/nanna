import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:hive/hive.dart';

part 'synchronizable_topic_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.synchronizableTopicEntity)
class SynchronizableTopicEntity extends SynchronizableEntity<TopicEntity> {
  SynchronizableTopicEntity({
    required super.dataId,
    required super.data,
    required super.createdAt,
    required super.synchronizedAt,
    required super.expirationDate,
  });
}
