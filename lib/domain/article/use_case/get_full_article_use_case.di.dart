import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFullArticleUseCase {
  final ArticleRepository _articleRepository;

  GetFullArticleUseCase(this._articleRepository);

  Future<Article> call(String slug) => _articleRepository.getFullArticle(slug);
}
