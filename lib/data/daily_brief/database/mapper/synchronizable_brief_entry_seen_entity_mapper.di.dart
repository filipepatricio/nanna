import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_seen_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/synchronizable_brief_entry_seen_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entry_seen_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/synchronization/database/mapper/synchronziable_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizableBriefEntrySeenEntityMapper
    extends SynchronizableEntityMapper<BriefEntrySeenEntity, BriefEntrySeen> {
  SynchronizableBriefEntrySeenEntityMapper(BriefEntrySeenEntityMapper mapper) : super(mapper);

  @override
  SynchronizableEntity<BriefEntrySeenEntity> createEntity({
    required BriefEntrySeenEntity? data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  }) {
    return SynchronizableBriefEntrySeenEntity(
      data: data,
      dataId: dataId,
      createdAt: createdAt,
      synchronizedAt: synchronizedAt,
      expirationDate: expirationDate,
    );
  }
}
