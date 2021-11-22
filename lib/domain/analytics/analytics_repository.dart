import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';

abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<void> login(String userId, String method);

  Future<void> logout();

  void page(String name);

  void pageV2(AnalyticsPage page);

  void dailyBriefPage(String briefId);

  void topicPage(String topicId);

  void articlePage(String articleId, [String? topicId]);

  void exploreAreaPage(String exploreAreaId);

  void event(AnalyticsEvent event);
}
