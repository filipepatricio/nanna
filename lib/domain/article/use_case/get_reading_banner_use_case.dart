import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReadingBannerStreamUseCase {
  final ArticleRepository _articleRepository;

  GetReadingBannerStreamUseCase(this._articleRepository);

  Stream<ReadingBanner> call() => _articleRepository.getReadingBannerStream();
}
