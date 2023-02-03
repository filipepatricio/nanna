import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadLocalArticleUseCase {
  LoadLocalArticleUseCase(this._articleLocalRepository);

  final ArticleLocalRepository _articleLocalRepository;

  Future<Article?> call(String slug) async {
    final synchronizable = await _articleLocalRepository.load(slug);

    if (synchronizable is Synchronized<Article>) {
      return synchronizable.data;
    }

    return null;
  }
}
