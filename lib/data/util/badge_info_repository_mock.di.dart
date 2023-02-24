import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/util/badge_info_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BadgeInfoRepository, env: mockEnvs)
class BadgeInfoRepositoryMock implements BadgeInfoRepository {
  @override
  Future<bool> shouldRefreshDailyBrief() async {
    return Future.value(false);
  }

  @override
  Future<void> needsRefreshDailyBrief(int badgeCount) async {}
}
