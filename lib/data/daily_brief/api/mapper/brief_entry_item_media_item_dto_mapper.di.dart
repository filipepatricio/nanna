import 'package:better_informed_mobile/data/article/api/mapper/article_curation_info_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_kind_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_progress_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/mapper/article_image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryMediaItemDTOMapper implements Mapper<BriefEntryItemDTO, MediaItem?> {
  BriefEntryMediaItemDTOMapper(
    this._articleImageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
    this._articleKindDTOMapper,
    this._articleProgressDTOMapper,
    this._categoryDTOMapper,
    this._articleCurationInfoDTOMapper,
  );
  final ArticleImageDTOMapper _articleImageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;
  final ArticleKindDTOMapper _articleKindDTOMapper;
  final ArticleProgressDTOMapper _articleProgressDTOMapper;
  final CategoryDTOMapper _categoryDTOMapper;
  final ArticleCurationInfoDTOMapper _articleCurationInfoDTOMapper;

  @override
  MediaItem? call(BriefEntryItemDTO data) {
    return data.map(
      article: (data) {
        final image = data.image;
        final publicationDate = data.publicationDate;
        final kind = data.kind;

        return MediaItem.article(
          id: data.id,
          slug: data.slug,
          url: data.url,
          title: data.title,
          strippedTitle: data.strippedTitle,
          note: data.note,
          credits: data.credits,
          timeToRead: data.timeToRead,
          type: _articleTypeDTOMapper(data.type),
          kind: kind != null ? _articleKindDTOMapper(kind) : null,
          publicationDate: publicationDate != null ? DateTime.parse(publicationDate).toLocal() : null,
          image: image != null ? _articleImageDTOMapper(image) : null,
          publisher: _publisherDTOMapper(data.publisher),
          sourceUrl: data.sourceUrl,
          author: data.author,
          availableInSubscription: data.availableInSubscription,
          hasAudioVersion: data.hasAudioVersion,
          progress: _articleProgressDTOMapper(data.progress),
          progressState: data.progressState,
          locked: data.locked,
          category: _categoryDTOMapper(data.category),
          curationInfo: _articleCurationInfoDTOMapper(data.curationInfo),
        );
      },
      topicPreview: (_) => null,
      unknown: (_) => const MediaItem.unknown(),
    );
  }
}
