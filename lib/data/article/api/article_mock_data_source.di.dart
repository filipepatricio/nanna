import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/topic_media_items_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/update_article_progress_response_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_item_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ArticleApiDataSource, env: mockEnvs)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  @override
  Future<ArticleContentDTO> getArticleContent(String slug) async {
    return MockDTO.articleContentMarkdown;
  }

  @override
  Future<ArticleHeaderDTO> getArticleHeader(String slug) async {
    if (slug == MockDTO.premiumArticleWithAudioLocked.slug) {
      return MockDTO.premiumArticleWithAudioLocked;
    }
    if (slug == MockDTO.premiumArticleWithAudio.slug) {
      return MockDTO.premiumArticleWithAudio;
    }
    if (slug == MockDTO.premiumArticleWithoutImage.slug) {
      return MockDTO.premiumArticleWithoutImage;
    }
    return MockDTO.premiumArticle;
  }

  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh) async {
    return MockDTO.audioFile;
  }

  @override
  Future<List<BriefEntryItemDTO>> getOtherBriefEntries(String articleSlug, String? briefId) async {
    return MockDTO.currentBrief().allEntries.map((entry) => entry.item).toList();
  }

  @override
  void trackAudioPosition(String articleSlug, int position) {}

  @override
  Future<UpdateArticleProgressResponseDTO> trackReadingProgress(String articleSlug, int progress) async {
    return MockDTO.updateArticleProgressResponse;
  }

  @override
  Future<TopicMediaItemsDTO> getOtherTopicEntries(String articleSlug, String topicSlug) async {
    return MockDTO.otherTopicEntries;
  }

  @override
  Future<List<CategoryItemDTO>> getRelatedContent(String slug) async {
    return MockDTO.categoryItemList;
  }

  @override
  Future<SuccessfulResponseDTO> markArticleAsSeen(String articleSlug) async {
    return SuccessfulResponseDTO(true);
  }
}
