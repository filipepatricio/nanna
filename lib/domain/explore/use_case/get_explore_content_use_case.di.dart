import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExploreContentUseCase {
  GetExploreContentUseCase(this._exploreContentRepository);

  final ExploreContentRepository _exploreContentRepository;

  Future<ExploreContent> call() async {
    final content = await _exploreContentRepository.getExploreContent();
    return _filterOutEmptyAreas(content);
  }

  Future<ExploreContent> guest() async {
    final content = await _exploreContentRepository.getExploreContentGuest();
    return _filterOutEmptyAreas(content);
  }

  Stream<ExploreContent> get exploreContentStream =>
      _exploreContentRepository.exploreContentStream().map(_filterOutEmptyAreas);

  ExploreContent _filterOutEmptyAreas(ExploreContent content) {
    final notEmptyAreas = content.areas.where(_isNotEmptyArea).toList();
    return ExploreContent(pills: content.pills, areas: notEmptyAreas);
  }

  bool _isNotEmptyArea(ExploreContentArea areas) {
    return areas.map(
      articles: (area) => area.articles.isNotEmpty,
      articlesList: (area) => area.articles.isNotEmpty,
      smallTopics: (area) => area.topics.isNotEmpty,
      unknown: (_) => false,
    );
  }
}
