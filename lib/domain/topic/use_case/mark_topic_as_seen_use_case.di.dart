import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkTopicAsSeenUseCase {
  MarkTopicAsSeenUseCase(this._topicsRepository);

  final TopicsRepository _topicsRepository;

  Future<bool> call(String slug) => _topicsRepository.markTopicAsSeen(slug);
}
