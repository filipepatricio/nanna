import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

abstract class ArticleRepository {
  Stream<ReadingBanner> getReadingBannerStream();

  Future<void> setReadingBannerState(ReadingBanner readingBanner);

  Future<MediaItemArticle> getArticleHeader(String slug);

  Future<ArticleContent> getArticleContent(String slug);

  Future<Article> getFullArticle(String slug);

  Future<AudioFile> getArticleAudioFile(String slug, [bool forceFresh = false]);
}
