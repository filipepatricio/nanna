import 'dart:async';

import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/audio_file_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/update_article_progress_response_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dt.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(
    this._articleDataSource,
    this._articleDTOToMediaItemMapper,
    this._articleContentDTOMapper,
    this._audioFileDTOMapper,
    this._briefEntryItemDTOMapper,
    this._mediaItemDTOMapper,
    this._categoryItemDTOMapper,
    this._updateArticleProgressResponseDTOMapper,
    this._articleDTOMapper,
  );

  final ArticleApiDataSource _articleDataSource;
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final ArticleContentDTOMapper _articleContentDTOMapper;
  final AudioFileDTOMapper _audioFileDTOMapper;
  final BriefEntryItemDTOMapper _briefEntryItemDTOMapper;
  final MediaItemDTOMapper _mediaItemDTOMapper;
  final CategoryItemDTOMapper _categoryItemDTOMapper;
  final UpdateArticleProgressResponseDTOMapper _updateArticleProgressResponseDTOMapper;
  final ArticleDTOMapper _articleDTOMapper;

  final Map<String, double> _audioProgress = {};
  final Map<String, int> _readProgress = {};

  final BehaviorSubject<ReadingBanner> _broadcaster = BehaviorSubject();

  var _freeArticlesLeftWarningStream = StreamController<String>.broadcast();

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
  Future<MediaItemArticle> getArticleHeader(String slug) async {
    final dto = await _articleDataSource.getArticleHeader(slug);
    return _articleDTOToMediaItemMapper(dto);
  }

  @override
  Future<AudioFile> getArticleAudioFile(String slug, [bool forceFresh = false]) async {
    final dto = await _articleDataSource.getArticleAudioFile(slug, forceFresh);
    return _audioFileDTOMapper(dto);
  }

  @override
  Future<List<BriefEntryItem>> getOtherBriefEntries(String articleSlug, String briefId) async {
    final dto = await _articleDataSource.getOtherBriefEntries(articleSlug, briefId);
    return dto.map<BriefEntryItem>(_briefEntryItemDTOMapper).toList();
  }

  @override
  Future<UpdateArticleProgressResponse> trackAudioPosition(String articleSlug, int position, [int? duration]) async {
    _audioProgress[articleSlug] = position / (duration ?? 1);

    final dto = await _articleDataSource.trackAudioPosition(articleSlug, position);

    if (dto.freeArticlesLeftWarning != null) {
      _freeArticlesLeftWarningStream.add(dto.freeArticlesLeftWarning!);
    }

    return _updateArticleProgressResponseDTOMapper(dto);
  }

  @override
  Future<UpdateArticleProgressResponse> trackReadingProgress(String articleSlug, int progress) async {
    _readProgress[articleSlug] = progress;

    final dto = await _articleDataSource.trackReadingProgress(articleSlug, progress);

    if (dto.freeArticlesLeftWarning != null) {
      _freeArticlesLeftWarningStream.add(dto.freeArticlesLeftWarning!);
    }

    return _updateArticleProgressResponseDTOMapper(dto);
  }

  @override
  Future<List<MediaItem>> getOtherTopicEntries(String articleSlug, String topicSlug) async {
    final dto = await _articleDataSource.getOtherTopicEntries(articleSlug, topicSlug);
    return dto.getOtherTopicEntries.map<MediaItem>(_mediaItemDTOMapper).toList();
  }

  @override
  Future<List<CategoryItem>> getRelatedContent(String slug) async {
    final dto = await _articleDataSource.getRelatedContent(slug);
    return dto.map<CategoryItem>(_categoryItemDTOMapper).toList();
  }

  @override
  double getArticleAudioProgress(MediaItemArticle article) {
    return _audioProgress[article.slug] ?? article.progress.audioProgress / 100;
  }

  @override
  int getArticleReadProgress(MediaItemArticle article) {
    return _readProgress[article.slug] ?? article.progress.contentProgress;
  }

  @override
  Stream<String> get freeArticlesLeftWarningStream => _freeArticlesLeftWarningStream.stream;

  @override
  void dispose() {
    _freeArticlesLeftWarningStream.close();
    _freeArticlesLeftWarningStream = StreamController<String>.broadcast();
  }

  @override
  Future<bool> markArticleAsSeen(String slug) async {
    final dto = await _articleDataSource.markArticleAsSeen(slug);
    return dto.successful;
  }

  @override
  Future<Article> getArticle(String slug, bool hasAudio) async {
    final dto = await _articleDataSource.getArticle(slug, hasAudio);
    return _articleDTOMapper(dto);
  }

  @override
  Future<List<Article>> getArticleList(List<String> slugs) async {
    final dto = await _articleDataSource.getArticleBatch(slugs);
    return dto.map<Article>(_articleDTOMapper).toList();
  }
}
