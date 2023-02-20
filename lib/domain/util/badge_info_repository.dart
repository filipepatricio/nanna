abstract class BadgeInfoRepository {
  Future<bool> shouldRefreshDailyBrief();

  Future<void> needsRefreshDailyBrief(int badgeCount);
}
