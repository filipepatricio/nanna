import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BadgeInfoRepository, env: mockEnvs)
class BadgeInfoRepositoryMock implements BadgeInfoRepository {
  @override
  Future<bool> shouldRefreshDailyBrief() async {
    return Future.value(false);
  }

  @override
  Future<void> updateBadgeCount(int badgeCount) async {}

  @override
  Future<bool> shouldShowDailyBriefBadge() {
    return Future.value(true);
  }

  @override
  Future<bool> setShouldShowDailyBriefBadge(bool showShowBadge) async {
    return Future.value(true);
  }

  @override
  Future<void> setNeedsRefreshDailyBrief(bool needsRefreshDailyBrief) async {}
}
