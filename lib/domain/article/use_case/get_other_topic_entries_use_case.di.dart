import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOtherTopicEntriesUseCase {
  const GetOtherTopicEntriesUseCase(this._repository);

  final ArticleRepository _repository;

  Future<List<MediaItem>> call(
    String articleSlug,
    String topicSlug,
  ) =>
      _repository.getOtherTopicEntries(
        articleSlug,
        topicSlug,
      );
}
