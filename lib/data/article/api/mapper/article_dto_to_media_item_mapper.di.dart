import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_kind_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_progress_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/article_image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleDTOToMediaItemMapper implements Mapper<ArticleHeaderDTO, MediaItemArticle> {
  ArticleDTOToMediaItemMapper(
    this._articleImageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
    this._articleKindDTOMapper,
    this._articleProgressDTOMapper,
  );
  final ArticleImageDTOMapper _articleImageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;
  final ArticleKindDTOMapper _articleKindDTOMapper;
  final ArticleProgressDTOMapper _articleProgressDTOMapper;

  @override
  MediaItemArticle call(ArticleHeaderDTO data) {
    final image = data.image;
    final publicationDate = data.publicationDate;
    final kind = data.kind;

    return MediaItemArticle(
      id: data.id,
      slug: data.slug,
      url: data.url,
      title: data.title,
      strippedTitle: data.strippedTitle,
      note: data.note,
      credits: data.credits,
      type: _articleTypeDTOMapper(data.type),
      kind: kind != null ? _articleKindDTOMapper(kind) : null,
      timeToRead: data.timeToRead,
      publisher: _publisherDTOMapper(data.publisher),
      sourceUrl: data.sourceUrl,
      author: data.author,
      image: image != null ? _articleImageDTOMapper(image) : null,
      publicationDate: publicationDate != null ? DateTime.parse(publicationDate).toLocal() : null,
      hasAudioVersion: data.hasAudioVersion,
      progress: _articleProgressDTOMapper(data.progress),
      progressState: data.progressState,
    );
  }
}
