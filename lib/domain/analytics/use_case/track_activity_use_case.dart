import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackActivityUseCase {
  final AnalyticsRepository _analyticsRepository;

  TrackActivityUseCase(this._analyticsRepository);

  Future<void> logDailyBriefPage(String briefId) => _analyticsRepository.dailyBriefPage(briefId);

  Future<void> logTopicPage(String topicId) => _analyticsRepository.topicPage(topicId);

  Future<void> logArticlePage(String articleId, [String? topicId]) =>
      _analyticsRepository.articlePage(articleId, topicId);

  Future<void> logExploreAreaPage(String exploreAreaId) => _analyticsRepository.exploreAreaPage(exploreAreaId);

  Future<void> logPage(String name) => _analyticsRepository.page(name);
}
