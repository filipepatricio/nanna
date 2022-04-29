import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExploreContentUseCase {
  final ExploreContentRepository _exploreContentRepository;

  GetExploreContentUseCase(this._exploreContentRepository);

  Future<ExploreContent> call({required bool showPills, required bool showAllStreamsInPills}) async {
    final content = showPills
        ? await _exploreContentRepository.getExploreHighlightedContent(showAllStreamsInPills: showAllStreamsInPills)
        : await _exploreContentRepository.getExploreContent();
    final notEmptyAreas = content.areas.where(_isNotEmptyArea).toList();
    return ExploreContent(pills: content.pills, areas: notEmptyAreas);
  }

  bool _isNotEmptyArea(ExploreContentArea areas) {
    return areas.map(
      articles: (area) => area.articles.isNotEmpty,
      articleWithFeature: (area) => area.articles.isNotEmpty,
      topics: (area) => area.topics.isNotEmpty,
      unknown: (_) => false,
    );
  }
}
