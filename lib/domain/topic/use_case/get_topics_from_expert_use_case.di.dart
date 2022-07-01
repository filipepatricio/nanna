import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTopicsFromExpertUseCase {
  GetTopicsFromExpertUseCase(this._topicsRepository);
  final TopicsRepository _topicsRepository;

  Future<List<TopicPreview>> call(
    String expertId, [
    String? excludedTopicSlug,
  ]) =>
      _topicsRepository.getTopicPreviewsFromExpert(expertId, excludedTopicSlug);
}
