import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_entry_seen_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefEntrySeenLocalRepository, env: mockEnvs)
class DailyBriefEntrySeenLocalRepositoryMock implements DailyBriefEntrySeenLocalRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> deleteAll() async {}

  @override
  Future<List<String>> getAllIds() async {
    return [];
  }

  @override
  Future<Synchronizable<BriefEntrySeen>?> load(String id) async {
    return null;
  }

  @override
  Future<void> save(Synchronizable<BriefEntrySeen> synchronizable) async {}
}
