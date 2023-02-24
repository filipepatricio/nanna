import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefLocalRepository, env: mockEnvs)
class DailyBriefLocalRepositoryMock implements DailyBriefLocalRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<String>> getAllIds() async {
    return [];
  }

  @override
  Future<Synchronizable<Brief>?> load(String id) async {
    return null;
  }

  @override
  Future<void> save(Synchronizable<Brief> synchronizable) async {}

  @override
  Future<void> deleteAll() async {}
}
