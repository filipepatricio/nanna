import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleReadingProgressUseCase {
  const TrackArticleReadingProgressUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<UpdateArticleProgressResponse> call(String slug, int progress) =>
      _articleRepository.trackReadingProgress(slug, progress);
}
