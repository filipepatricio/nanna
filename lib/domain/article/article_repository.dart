import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dt.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

abstract class ArticleRepository {
  Stream<ReadingBanner> getReadingBannerStream();

  Future<void> setReadingBannerState(ReadingBanner readingBanner);

  Future<MediaItemArticle> getArticleHeader(String slug);

  Future<ArticleContent> getArticleContent(String slug);

  Future<AudioFile> getArticleAudioFile(String slug, [bool forceFresh = false]);

  Future<Article> getArticle(String slug, bool hasAudio);

  Future<List<Article>> getArticleList(List<String> slugs);

  Future<List<BriefEntryItem>> getOtherBriefEntries(String articleSlug, String briefId);

  Future<UpdateArticleProgressResponse> trackReadingProgress(String articleSlug, int progress);

  void trackAudioPosition(String articleSlug, int position, [int? duration]);

  Future<List<MediaItem>> getOtherTopicEntries(String articleSlug, String topicSlug);

  Future<List<CategoryItem>> getRelatedContent(String slug);

  double getArticleAudioProgress(MediaItemArticle article);

  int getArticleReadProgress(MediaItemArticle article);

  Stream<String> get freeArticlesLeftWarningStream;

  Future<bool> markArticleAsSeen(String slug);

  void dispose();
}
