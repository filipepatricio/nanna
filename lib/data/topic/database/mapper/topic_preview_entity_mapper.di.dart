import 'package:better_informed_mobile/data/article/database/mapper/category_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/curation_info_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/image_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_preview_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/topic_publisher_information_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicPreviewEntityMapper implements BidirectionalMapper<TopicPreviewEntity, TopicPreview> {
  TopicPreviewEntityMapper(
    this._curationInfoEntityMapper,
    this._topicPublisherInformationEntityMapper,
    this._categoryEntityMapper,
    this._imageEntityMapper,
  );

  final CurationInfoEntityMapper _curationInfoEntityMapper;
  final TopicPublisherInformationEntityMapper _topicPublisherInformationEntityMapper;
  final CategoryEntityMapper _categoryEntityMapper;
  final ImageEntityMapper _imageEntityMapper;

  @override
  TopicPreviewEntity from(TopicPreview data) {
    return TopicPreviewEntity(
      id: data.id,
      slug: data.slug,
      title: data.title,
      strippedTitle: data.strippedTitle,
      introduction: data.introduction,
      ownersNote: data.ownersNote,
      url: data.url,
      curationInfo: _curationInfoEntityMapper.from(data.curationInfo),
      lastUpdatedAt: data.lastUpdatedAt,
      publisherInformation: _topicPublisherInformationEntityMapper.from(data.publisherInformation),
      heroImage: _imageEntityMapper.from(data.heroImage),
      entryCount: data.entryCount,
      visited: data.visited,
      category: _categoryEntityMapper.from(data.category),
    );
  }

  @override
  TopicPreview to(TopicPreviewEntity data) {
    return TopicPreview(
      data.id,
      data.slug,
      data.title,
      data.strippedTitle,
      data.introduction,
      data.ownersNote,
      data.url,
      _curationInfoEntityMapper.to(data.curationInfo),
      data.lastUpdatedAt,
      _topicPublisherInformationEntityMapper.to(data.publisherInformation),
      _imageEntityMapper.to(data.heroImage),
      data.entryCount,
      data.visited,
      _categoryEntityMapper.to(data.category),
    );
  }
}
