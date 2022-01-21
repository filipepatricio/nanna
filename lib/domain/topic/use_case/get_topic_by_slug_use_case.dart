import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTopicBySlugUseCase {
  final TopicsRepository _topicsRepository;

  GetTopicBySlugUseCase(this._topicsRepository);

  Future<Topic> call(String slug) => _topicsRepository.getTopicBySlug(slug);
}
