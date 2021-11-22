import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackActivityUseCase {
  final AnalyticsRepository _analyticsRepository;

  TrackActivityUseCase(this._analyticsRepository);

  void trackDailyBriefPage(String briefId) => _analyticsRepository.dailyBriefPage(briefId);

  void trackTopicPage(String topicId) => _analyticsRepository.topicPage(topicId);

  void trackArticlePage(String articleId, [String? topicId]) => _analyticsRepository.articlePage(articleId, topicId);

  void trackExploreAreaPage(String exploreAreaId) => _analyticsRepository.exploreAreaPage(exploreAreaId);

  void trackPage(String name) => _analyticsRepository.page(name);

  void trackPageV2(AnalyticsPage page) => _analyticsRepository.pageV2(page);

  void trackEvent(AnalyticsEvent event) => _analyticsRepository.event(event);
}
