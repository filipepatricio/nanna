import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExplorePaginatedTopicsUseCase {
  GetExplorePaginatedTopicsUseCase(this._exploreContentRepository);
  final ExploreContentRepository _exploreContentRepository;

  Future<List<TopicPreview>> call(String areaId, int limit, int offset) {
    return _exploreContentRepository.getPaginatedTopics(areaId, limit, offset);
  }
}
