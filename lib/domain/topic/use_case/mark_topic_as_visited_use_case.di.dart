import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkTopicAsVisitedUseCase {
  MarkTopicAsVisitedUseCase(this._topicsRepository);

  final TopicsRepository _topicsRepository;

  Future<void> call(String slug) => _topicsRepository.markTopicAsVisited(slug);
}
