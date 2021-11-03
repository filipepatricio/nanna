import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExploreContentUseCase {
  final ExploreContentRepository _exploreContentRepository;

  GetExploreContentUseCase(this._exploreContentRepository);

  Future<ExploreContent> call() async {
    final content = await _exploreContentRepository.getExploreContent();
    final notEmptySections = content.sections.where(_isNotEmptySection).toList();
    return ExploreContent(sections: notEmptySections);
  }

  bool _isNotEmptySection(ExploreContentSection section) {
    return section.map(
      articles: (section) => section.articles.isNotEmpty,
      articleWithFeature: (section) => section.articles.isNotEmpty,
      topics: (section) => section.topics.isNotEmpty,
    );
  }
}
