import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExploreContentUseCase {
  final ExploreContentRepository _exploreContentRepository;

  GetExploreContentUseCase(this._exploreContentRepository);

  Future<ExploreContent> call() async {
    final content = await _exploreContentRepository.getExploreContent();
    final notEmptySections = content.areas.where(_isNotEmptySection).toList();
    return ExploreContent(areas: notEmptySections);
  }

  bool _isNotEmptySection(ExploreContentArea areas) {
    return areas.map(
      articles: (area) => area.articles.isNotEmpty,
      articleWithFeature: (area) => area.articles.isNotEmpty,
      topics: (area) => area.topics.isNotEmpty,
    );
  }
}
