import 'package:better_informed_mobile/data/article/database/entity/article_header_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_image_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_kind_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_progress_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_progress_state_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_type_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/category_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/curation_info_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/publisher_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleHeaderEntityMapper extends BidirectionalMapper<ArticleHeaderEntity, MediaItemArticle> {
  ArticleHeaderEntityMapper(
    this._articleTypeEntityMapper,
    this._articleKindEntityMapper,
    this._publisherEntityMapper,
    this._articleImageEntityMapper,
    this._articleProgressEntityMapper,
    this._articleProgressStateEntityMapper,
    this._categoryEntityMapper,
    this._curationInfoEntityMapper,
  );

  final ArticleTypeEntityMapper _articleTypeEntityMapper;
  final ArticleKindEntityMapper _articleKindEntityMapper;
  final PublisherEntityMapper _publisherEntityMapper;
  final ArticleImageEntityMapper _articleImageEntityMapper;
  final ArticleProgressEntityMapper _articleProgressEntityMapper;
  final ArticleProgressStateEntityMapper _articleProgressStateEntityMapper;
  final CategoryEntityMapper _categoryEntityMapper;
  final CurationInfoEntityMapper _curationInfoEntityMapper;

  @override
  ArticleHeaderEntity from(MediaItemArticle data) {
    final kind = data.kind;
    final image = data.image;

    return ArticleHeaderEntity(
      id: data.id,
      title: data.title,
      url: data.url,
      author: data.author,
      availableInSubscription: data.availableInSubscription,
      hasAudioVersion: data.hasAudioVersion,
      locked: data.locked,
      note: data.note,
      isNoteCollapsible: data.isNoteCollapsible,
      publicationDate: data.publicationDate?.toIso8601String(),
      slug: data.slug,
      sourceUrl: data.sourceUrl,
      strippedTitle: data.strippedTitle,
      timeToRead: data.timeToRead,
      type: _articleTypeEntityMapper.from(data.type),
      kind: kind != null ? _articleKindEntityMapper.from(kind) : null,
      publisher: _publisherEntityMapper.from(data.publisher),
      image: image != null ? _articleImageEntityMapper.from(image) : null,
      progress: _articleProgressEntityMapper.from(data.progress),
      progressState: _articleProgressStateEntityMapper.from(data.progressState),
      category: _categoryEntityMapper.from(data.category),
      curationInfo: _curationInfoEntityMapper.from(data.curationInfo),
    );
  }

  @override
  MediaItemArticle to(ArticleHeaderEntity data) {
    final kind = data.kind;
    final image = data.image;
    final publicationDate = data.publicationDate;

    return MediaItem.article(
      id: data.id,
      slug: data.slug,
      url: data.url,
      title: data.title,
      strippedTitle: data.strippedTitle,
      note: data.note,
      isNoteCollapsible: data.isNoteCollapsible,
      type: _articleTypeEntityMapper.to(data.type),
      kind: kind != null ? _articleKindEntityMapper.to(kind) : null,
      timeToRead: data.timeToRead,
      publisher: _publisherEntityMapper.to(data.publisher),
      hasAudioVersion: data.hasAudioVersion,
      availableInSubscription: data.availableInSubscription,
      sourceUrl: data.sourceUrl,
      progressState: _articleProgressStateEntityMapper.to(data.progressState),
      progress: _articleProgressEntityMapper.to(data.progress),
      locked: data.locked,
      category: _categoryEntityMapper.to(data.category),
      curationInfo: _curationInfoEntityMapper.to(data.curationInfo),
      author: data.author,
      image: image != null ? _articleImageEntityMapper.to(image) : null,
      publicationDate: publicationDate != null ? DateTime.parse(publicationDate) : null,
    ) as MediaItemArticle;
  }
}
