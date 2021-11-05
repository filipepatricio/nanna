import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExplorePaginatedArticlesUseCase {
  final ExploreContentRepository _exploreContentRepository;

  GetExplorePaginatedArticlesUseCase(this._exploreContentRepository);

  Future<List<MediaItemArticle>> call(String sectionId, int limit, int offset) {
    return _exploreContentRepository.getPaginatedArticles(sectionId, limit, offset);
  }
}
