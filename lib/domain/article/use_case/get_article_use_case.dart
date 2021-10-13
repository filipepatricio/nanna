import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleUseCase {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  Future<Article> call(ArticleHeader articleHeader) async {
    final content = await _articleRepository.getArticleContent(articleHeader.slug);
    return Article(
      content: content,
      header: articleHeader,
    );
  }
}
