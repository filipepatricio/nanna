import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleContentUseCase {
  final ArticleRepository _articleRepository;

  GetArticleContentUseCase(this._articleRepository);

  Future<ArticleContent> call(String slug) => _articleRepository.getArticleContent(slug);
}
