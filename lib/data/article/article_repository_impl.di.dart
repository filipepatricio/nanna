import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'api/mapper/audio_file_dto_mapper.di.dart';

@LazySingleton(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleApiDataSource _articleDataSource;
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final ArticleContentDTOMapper _articleContentDTOMapper;
  final ArticleDTOMapper _articleDTOMapper;
  final AudioFileDTOMapper _audioFileDTOMapper;

  final BehaviorSubject<ReadingBanner> _broadcaster = BehaviorSubject();

  ArticleRepositoryImpl(
    this._articleDataSource,
    this._articleDTOToMediaItemMapper,
    this._articleContentDTOMapper,
    this._articleDTOMapper,
    this._audioFileDTOMapper,
  );

  @override
  Stream<ReadingBanner> getReadingBannerStream() => _broadcaster.stream;

  @override
  Future<void> setReadingBannerState(ReadingBanner readingBanner) async => _broadcaster.add(readingBanner);

  @override
  Future<ArticleContent> getArticleContent(String slug) async {
    final dto = await _articleDataSource.getArticleContent(slug);
    return _articleContentDTOMapper(dto);
  }

  @override
  Future<Article> getFullArticle(String slug) async {
    final dto = await _articleDataSource.getFullArticle(slug);
    return _articleDTOMapper(dto);
  }

  @override
  Future<MediaItemArticle> getArticleHeader(String slug) async {
    final dto = await _articleDataSource.getArticleHeader(slug);
    return _articleDTOToMediaItemMapper(dto);
  }

  @override
  Future<AudioFile> getArticleAudioFile(String slug, [bool forceFresh = false]) async {
    final dto = await _articleDataSource.getArticleAudioFile(slug, forceFresh);
    return _audioFileDTOMapper(dto);
  }
}
