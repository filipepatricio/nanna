import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExplorePaginatedTopicsUseCase {
  final ExploreContentRepository _exploreContentRepository;

  GetExplorePaginatedTopicsUseCase(this._exploreContentRepository);

  Future<List<Topic>> call(String sectionId, int limit, int offset) {
    return _exploreContentRepository.getPaginatedTopics(sectionId, limit, offset);
  }
}
