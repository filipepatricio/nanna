import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFreeArticlesLeftWarningStreamUseCase {
  const GetFreeArticlesLeftWarningStreamUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Stream<String> call() => _articleRepository.freeArticlesLeftWarningStream;
}
