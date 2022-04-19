import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/article_image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleDTOToMediaItemMapper implements Mapper<ArticleHeaderDTO, MediaItemArticle> {
  final ArticleImageDTOMapper _articleImageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;

  ArticleDTOToMediaItemMapper(
    this._articleImageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
  );

  @override
  MediaItemArticle call(ArticleHeaderDTO data) {
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
      image: image != null ? _articleImageDTOMapper(image) : null,
      publicationDate: publicationDate != null ? DateTime.parse(publicationDate).toLocal() : null,
      hasAudioVersion: data.hasAudioVersion,
    );
  }
}
