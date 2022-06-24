import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';

abstract class ArticleApiDataSource {
  Future<ArticleHeaderDTO> getArticleHeader(String slug);

  Future<ArticleContentDTO> getArticleContent(String slug);

  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh);

  void trackReadingProgress(String articleSlug, int progress);

  void trackAudioPosition(String articleSlug, int position);
}
