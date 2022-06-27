import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExplorePaginatedArticlesUseCase {
  GetExplorePaginatedArticlesUseCase(this._exploreContentRepository);
  final ExploreContentRepository _exploreContentRepository;

  Future<List<MediaItemArticle>> call(String areaId, int limit, int offset) {
    return _exploreContentRepository.getPaginatedArticles(areaId, limit, offset);
  }
}
