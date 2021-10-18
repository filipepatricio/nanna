import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleApiDataSource _articleDataSource;
  final ArticleContentDTOMapper _articleContentDTOMapper;

  final BehaviorSubject<ReadingBanner> _broadcaster = BehaviorSubject();

  ArticleRepositoryImpl(
    this._articleDataSource,
    this._articleContentDTOMapper,
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
}
