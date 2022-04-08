import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTopicsFromExpertUseCase {
  final TopicsRepository _topicsRepository;

  GetTopicsFromExpertUseCase(this._topicsRepository);

  Future<List<Topic>> call(String expertId) => _topicsRepository.getTopicsFromExpert(expertId);
}