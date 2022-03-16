import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleDTOToMediaItemMapper implements Mapper<ArticleDTO, MediaItemArticle> {
  final ImageDTOMapper _imageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;

  ArticleDTOToMediaItemMapper(
    this._imageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
  );

  @override
  MediaItemArticle call(ArticleDTO data) {
    final image = data.image;
    final publicationDate = data.publicationDate;

    return MediaItemArticle(
      id: data.id,
      slug: data.slug,
      url: data.url,
      title: data.title,
      strippedTitle: data.strippedTitle,
      credits: data.credits,
      type: _articleTypeDTOMapper(data.type),
      timeToRead: data.timeToRead,
      publisher: _publisherDTOMapper(data.publisher),
      sourceUrl: data.sourceUrl,
      author: data.author,
      image: image != null ? _imageDTOMapper(image) : null,
      publicationDate: publicationDate != null ? DateTime.parse(publicationDate).toLocal() : null,
    );
  }
}
