import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';

abstract class DailyBriefLocalRepository implements SynchronizableRepository<Brief> {
  Future<void> deleteAll();
}
