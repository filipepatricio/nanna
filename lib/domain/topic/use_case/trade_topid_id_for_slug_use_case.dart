import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TradeTopicIdForSlugUseCase {
  TradeTopicIdForSlugUseCase(this._topicsRepository);

  final TopicsRepository _topicsRepository;

  Future<String> call(String slug) => _topicsRepository.tradeTopicIdForSlug(slug);
}
