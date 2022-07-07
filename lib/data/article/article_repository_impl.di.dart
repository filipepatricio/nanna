import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/audio_file_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
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
  );

  final ArticleApiDataSource _articleDataSource;
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final ArticleContentDTOMapper _articleContentDTOMapper;
  final AudioFileDTOMapper _audioFileDTOMapper;
  final BriefEntryItemDTOMapper _briefEntryItemDTOMapper;
  final MediaItemDTOMapper _mediaItemDTOMapper;

  final BehaviorSubject<ReadingBanner> _broadcaster = BehaviorSubject();

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
  Future<List<BriefEntryItem>> getOtherBriefEntries(String articleSlug) async {
    final dto = await _articleDataSource.getOtherBriefEntries(articleSlug);
    return dto.map<BriefEntryItem>(_briefEntryItemDTOMapper).toList();
  }

  @override
  void trackAudioPosition(String articleSlug, int position) =>
      _articleDataSource.trackAudioPosition(articleSlug, position);

  @override
  void trackReadingProgress(String articleSlug, int progress) =>
      _articleDataSource.trackReadingProgress(articleSlug, progress);

  @override
  Future<List<MediaItem>> getOtherTopicEntries(String articleSlug, String topicSlug) async {
    final dto = await _articleDataSource.getOtherTopicEntries(articleSlug, topicSlug);
    return dto.getOtherTopicEntries.map<MediaItem>(_mediaItemDTOMapper).toList();
  }
}
