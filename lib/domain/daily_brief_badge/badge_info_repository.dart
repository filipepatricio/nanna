abstract class BadgeInfoRepository {
  Future<bool> shouldRefreshDailyBrief();

  Future<void> needsRefreshDailyBrief(int badgeCount);

  Future<bool> setShouldShowDailyBriefBadge(bool shouldShowDailyBriefBadge);

  Future<bool> shouldShowDailyBriefBadge();
}
