import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/util/image_precache/image_precache_broadcaster.di.dart';
import 'package:better_informed_mobile/domain/util/image_precache/image_precache_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResyncImagesForStoredArticlesUseCase {
  ResyncImagesForStoredArticlesUseCase(
    this._articleLocalRepository,
    this._imagePrecacheBroadcaster,
  );

  final ArticleLocalRepository _articleLocalRepository;
  final ImagePrecacheBroadcaster _imagePrecacheBroadcaster;

  Future<void> call() async {
    final articleIdList = await _articleLocalRepository.getAllIds();

    for (final articleId in articleIdList) {
      final articleSync = await _articleLocalRepository.load(articleId);
      final article = articleSync?.data;
      if (article == null) continue;

      final articleImage = ImagePrecacheData.article(article.metadata);
      _imagePrecacheBroadcaster.broadcast(articleImage);
    }
  }
}
