import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/topic_media_items_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/update_article_progress_response_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_item_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';

abstract class ArticleApiDataSource {
  Future<ArticleHeaderDTO> getArticleHeader(String slug);

  Future<ArticleContentDTO> getArticleContent(String slug);

  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh);

  Future<ArticleDTO> getArticle(String slug, bool hasAudio);

  Future<List<ArticleDTO>> getArticleBatch(List<String> slugs);

  Future<List<BriefEntryItemDTO>> getOtherBriefEntries(String articleSlug, String briefId);

  Future<TopicMediaItemsDTO> getOtherTopicEntries(String articleSlug, String topicSlug);

  Future<List<CategoryItemDTO>> getRelatedContent(String slug);

  Future<UpdateArticleProgressResponseDTO> trackReadingProgress(String articleSlug, int progress);

  void trackAudioPosition(String articleSlug, int position);

  Future<SuccessfulResponseDTO> markArticleAsSeen(String slug);
}
