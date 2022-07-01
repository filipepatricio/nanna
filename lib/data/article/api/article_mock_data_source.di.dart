import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/other_brief_entry_item_dto.dt.dart';
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
    if (slug == MockDTO.premiumArticleWithAudio.slug) {
      return MockDTO.premiumArticleWithAudio;
    }
    return MockDTO.premiumArticle;
  }

  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh) async {
    return MockDTO.audioFile;
  }

  @override
  void trackAudioPosition(String articleSlug, int position) {}

  @override
  void trackReadingProgress(String articleSlug, int progress) {}

  @override
  Future<List<OtherBriefEntryItemDTO>> getOtherBriefEntries(String articleSlug) {
    // TODO: implement otherBriefEntries
    throw UnimplementedError();
  }
}
