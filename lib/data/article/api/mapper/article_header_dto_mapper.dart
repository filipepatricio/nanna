import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleHeaderDTOMapper implements Mapper<ArticleDTO, ArticleHeader> {
  final ImageDTOMapper _imageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;

  ArticleHeaderDTOMapper(
    this._imageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
  );

  @override
  ArticleHeader call(ArticleDTO data) {
    final image = data.image;
    return ArticleHeader(
      slug: data.slug,
      title: data.title,
      type: _articleTypeDTOMapper(data.type),
      publicationDate: DateTime.parse(data.publicationDate).toLocal(),
      timeToRead: data.timeToRead,
      image: image != null ? _imageDTOMapper(image) : null,
      publisher: _publisherDTOMapper(data.publisher),
      author: data.author,
    );
  }
}
