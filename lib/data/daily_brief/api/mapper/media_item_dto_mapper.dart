import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/media_item_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class MediaItemDTOMapper implements Mapper<MediaItemDTO, MediaItem> {
  final ImageDTOMapper _imageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;

  MediaItemDTOMapper(
    this._imageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
  );

  @override
  MediaItem call(MediaItemDTO data) {
    return data.maybeMap(
      article: (MediaItemDTOArticle articleDTO) {
        final image = articleDTO.image;
        final publicationDate = articleDTO.publicationDate;

        return MediaItem.article(
          wordCount: articleDTO.wordCount,
          note: articleDTO.note,
          id: articleDTO.id,
          slug: articleDTO.slug,
          title: articleDTO.title,
          timeToRead: articleDTO.timeToRead,
          type: _articleTypeDTOMapper(articleDTO.type),
          publicationDate: publicationDate != null ? DateTime.parse(publicationDate).toLocal() : null,
          image: image != null ? _imageDTOMapper(image) : null,
          publisher: _publisherDTOMapper(articleDTO.publisher),
          sourceUrl: articleDTO.sourceUrl,
          author: articleDTO.author,
        );
      },
      orElse: () {
        throw Exception('Not supported media item type.');
      },
    );
  }
}
