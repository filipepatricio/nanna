import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:hive/hive.dart';

part 'synchronizable_brief_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.synchronizableBriefEntity)
class SynchronizableBriefEntity extends SynchronizableEntity<BriefEntity> {
  SynchronizableBriefEntity({
    required super.data,
    required super.dataId,
    required super.createdAt,
    required super.synchronizedAt,
    required super.expirationDate,
  });
}
