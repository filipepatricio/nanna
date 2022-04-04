import 'package:better_informed_mobile/data/article/api/dto/article_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleDTOMapper implements Mapper<ArticleDTO, Article> {
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final ArticleContentDTOMapper _articleContentDTOMapper;

  ArticleDTOMapper(
    this._articleDTOToMediaItemMapper,
    this._articleContentDTOMapper,
  );

  @override
  Article call(ArticleDTO data) {
    throwIf(
      data.text == null,
      AssertionError('Article content can not be null when requesting full article'),
    );

    return Article(
      content: _articleContentDTOMapper(data.text!),
      article: _articleDTOToMediaItemMapper(data),
    );
  }
}
