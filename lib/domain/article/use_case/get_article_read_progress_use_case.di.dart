import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleReadProgressUseCase {
  const GetArticleReadProgressUseCase(
    this._articleRepository,
  );

  final ArticleRepository _articleRepository;

  int call(MediaItemArticle article) => _articleRepository.getArticleReadProgress(article);
}
