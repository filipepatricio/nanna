import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_seen_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/synchronizable_brief_entry_seen_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_entry_seen_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:hive/hive.dart';

const _boxName = 'dailyBriefEntrySeen';

class DailyBriefEntrySeenHiveLocalRepository implements DailyBriefEntrySeenLocalRepository {
  DailyBriefEntrySeenHiveLocalRepository._(this._box, this._mapper);

  final LazyBox<SynchronizableEntity<BriefEntrySeenEntity>> _box;
  final SynchronizableBriefEntrySeenEntityMapper _mapper;

  static Future<DailyBriefEntrySeenHiveLocalRepository> create(SynchronizableBriefEntrySeenEntityMapper mapper) async {
    final box = await Hive.openLazyBox<SynchronizableEntity<BriefEntrySeenEntity>>(_boxName);
    return DailyBriefEntrySeenHiveLocalRepository._(box, mapper);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  Future<List<String>> getAllIds() async {
    return _box.keys.cast<String>().toList(growable: false);
  }

  @override
  Future<Synchronizable<BriefEntrySeen>?> load(String id) async {
    final synchronizable = await _box.get(id);

    if (synchronizable == null) {
      return null;
    }

    return _mapper.to(synchronizable);
  }

  @override
  Future<void> save(Synchronizable<BriefEntrySeen> synchronizable) async {
    final entity = _mapper.from(synchronizable);
    await _box.put(synchronizable.dataId, entity);
  }
}
