import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_calendar_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/daily_brief_calendar_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_calendar_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_calendar.dt.dart';
import 'package:hive_flutter/adapters.dart';

const _boxName = 'daily_brief_calendar';
const _key = 'calendar';

class DailyBriefCalendarHiveLocalRepository implements DailyBriefCalendarLocalRepository {
  DailyBriefCalendarHiveLocalRepository._(
    this._box,
    this._briefCalendarEntityMapper,
  );

  final LazyBox<BriefCalendarEntity> _box;
  final DailyBriefCalendarEntityMapper _briefCalendarEntityMapper;

  static Future<DailyBriefCalendarHiveLocalRepository> create(DailyBriefCalendarEntityMapper mapper) async {
    final box = await Hive.openLazyBox<BriefCalendarEntity>(_boxName);
    return DailyBriefCalendarHiveLocalRepository._(box, mapper);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<BriefCalendar?> load() async {
    final entity = await _box.get(_key);
    return entity == null ? null : _briefCalendarEntityMapper.to(entity);
  }

  @override
  Future<void> save(BriefCalendar calendar) async {
    await _box.put(_key, _briefCalendarEntityMapper.from(calendar));
  }
}
