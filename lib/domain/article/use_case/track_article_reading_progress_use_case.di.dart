import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleReadingProgressUseCase {
  const TrackArticleReadingProgressUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  void call(String articleSlug, int progress) => _articleRepository.trackReadingProgress(articleSlug, progress);
}
