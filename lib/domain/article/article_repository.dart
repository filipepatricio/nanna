import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';

abstract class ArticleRepository {
  Stream<ReadingBanner> getReadingBannerStream();

  Future<void> setReadingBannerState(ReadingBanner readingBanner);

  Future<Article> getFullArticle(String slug);
}
