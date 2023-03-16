import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_seen_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:hive/hive.dart';

part 'synchronizable_brief_entry_seen_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.synchronizableBriefEntrySeenEntity)
class SynchronizableBriefEntrySeenEntity extends SynchronizableEntity<BriefEntrySeenEntity> {
  SynchronizableBriefEntrySeenEntity({
    required super.data,
    required super.dataId,
    required super.createdAt,
    required super.synchronizedAt,
    required super.expirationDate,
  });
}
