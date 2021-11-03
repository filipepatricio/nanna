import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleUseCase {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  Future<Article> call(MediaItemArticle entry) async {
    final content = await _articleRepository.getArticleContent(entry.slug);
    return Article(
      content: content,
      entry: entry,
    );
  }
}
