abstract class BadgeInfoRepository {
  Future<bool> shouldRefreshDailyBrief();

  Future<void> updateBadgeCount(int badgeCount);

  Future<void> setNeedsRefreshDailyBrief(bool needsRefreshDailyBrief);

  Future<bool> setShouldShowDailyBriefBadge(bool shouldShowDailyBriefBadge);

  Future<bool> shouldShowDailyBriefBadge();
}
