import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleAudioPositionUseCase {
  const TrackArticleAudioPositionUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  void call(String articleSlug, int position) => _articleRepository.trackAudioPosition(articleSlug, position);
}
