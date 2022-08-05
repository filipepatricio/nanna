import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleReadingProgressUseCase {
  const TrackArticleReadingProgressUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<ArticleProgress> call(String slug, int progress) => _articleRepository.trackReadingProgress(slug, progress);
}
