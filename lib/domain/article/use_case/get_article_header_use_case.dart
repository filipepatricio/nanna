import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleHeaderUseCase {
  GetArticleHeaderUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<MediaItemArticle> call(String slug) => _articleRepository.getArticleHeader(slug);
}
