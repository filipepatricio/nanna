import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';

abstract class DailyBriefEntrySeenLocalRepository implements SynchronizableRepository<BriefEntrySeen> {
  Future<void> deleteAll();
}
