import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetReadingBannerStreamUseCase {
  SetReadingBannerStreamUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<void> call(ReadingBanner readingBanner) => _articleRepository.setReadingBannerState(readingBanner);
}
