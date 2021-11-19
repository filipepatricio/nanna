abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<void> login(String userId, String method);

  Future<void> logout();

  void page(String name);

  void dailyBriefPage(String briefId);

  void topicPage(String topicId);

  void articlePage(String articleId, [String? topicId]);

  void exploreAreaPage(String exploreAreaId);
}
