abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<void> login(String userId, String method);

  Future<void> logout();

  Future<void> page(String name);

  Future<void> dailyBriefPage(String briefId);

  Future<void> topicPage(String topicId);

  Future<void> articlePage(String articleId, [String? topicId]);

  Future<void> exploreAreaPage(String exploreAreaId);
}
