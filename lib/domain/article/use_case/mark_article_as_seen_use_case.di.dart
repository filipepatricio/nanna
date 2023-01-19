import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkArticleAsSeenUseCase {
  MarkArticleAsSeenUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<bool> call(String slug) => _articleRepository.markArticleAsSeen(slug);
}
