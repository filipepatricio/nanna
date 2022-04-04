import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';

abstract class ArticleApiDataSource {
  Future<ArticleDTO> getArticleHeader(String slug);

  Future<ArticleDTO> getFullArticle(String slug);

  Future<ArticleContentDTO> getArticleContent(String slug);

  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh);
}
