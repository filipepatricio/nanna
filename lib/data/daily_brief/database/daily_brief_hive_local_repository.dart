import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/synchronizable_brief_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:hive/hive.dart';

const _boxName = 'briefs_box';

class DailyBriefHiveLocalRepository implements DailyBriefLocalRepository {
  DailyBriefHiveLocalRepository._(this._box, this._mapper);

  final LazyBox<SynchronizableEntity<BriefEntity>> _box;
  final SynchronizableBriefEntityMapper _mapper;

  static Future<DailyBriefHiveLocalRepository> create(SynchronizableBriefEntityMapper mapper) async {
    final box = await Hive.openLazyBox<SynchronizableEntity<BriefEntity>>(_boxName);
    return DailyBriefHiveLocalRepository._(box, mapper);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<String>> getAllIds() async {
    return _box.keys.cast<String>().toList(growable: false);
  }

  @override
  Future<Synchronizable<Brief>?> load(String id) async {
    final entity = await _box.get(id);

    if (entity == null) {
      return null;
    }

    return _mapper.to(entity);
  }

  @override
  Future<void> save(Synchronizable<Brief> synchronizable) async {
    final entity = _mapper.from(synchronizable);
    await _box.put(entity.dataId, entity);
  }

  @override
  Future<void> deleteAll() {
    return _box.clear();
  }
}
