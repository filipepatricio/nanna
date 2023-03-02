abstract class BadgeInfoRepository {
  Future<bool> shouldRefreshDailyBrief();

  Future<void> needsRefreshDailyBrief(int badgeCount);

  Future<void> setShouldShowDailyBriefBadge(bool shouldShowDailyBriefBadge);

  Future<bool> isShowingDailyBriefBadge();
}
