import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackActivityUseCase {
  final AnalyticsRepository _analyticsRepository;

  TrackActivityUseCase(this._analyticsRepository);

  Future<void> trackDailyBriefPage(String briefId) => _analyticsRepository.dailyBriefPage(briefId);

  Future<void> trackTopicPage(String topicId) => _analyticsRepository.topicPage(topicId);

  Future<void> trackArticlePage(String articleId, [String? topicId]) =>
      _analyticsRepository.articlePage(articleId, topicId);

  Future<void> trackExploreAreaPage(String exploreAreaId) => _analyticsRepository.exploreAreaPage(exploreAreaId);

  Future<void> trackPage(String name) => _analyticsRepository.page(name);
}
