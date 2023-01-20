import 'package:better_informed_mobile/data/article/database/mapper/category_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/curation_info_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/image_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/topic_entry_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/topic_publisher_information_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicEntityMapper extends BidirectionalMapper<TopicEntity, Topic> {
  TopicEntityMapper(
    this._curationInfoEntityMapper,
    this._topicPublisherInformationEntityMapper,
    this._topicEntryEntityMapper,
    this._categoryEntityMapper,
    this._imageEntityMapper,
  );

  final CurationInfoEntityMapper _curationInfoEntityMapper;
  final TopicPublisherInformationEntityMapper _topicPublisherInformationEntityMapper;
  final TopicEntryEntityMapper _topicEntryEntityMapper;
  final CategoryEntityMapper _categoryEntityMapper;
  final ImageEntityMapper _imageEntityMapper;

  @override
  TopicEntity from(Topic data) {
    return TopicEntity(
      id: data.id,
      slug: data.slug,
      title: data.title,
      strippedTitle: data.strippedTitle,
      introduction: data.introduction,
      ownersNote: data.ownersNote,
      url: data.url,
      curationInfo: _curationInfoEntityMapper.from(data.curationInfo),
      summary: data.summary,
      lastUpdatedAt: data.lastUpdatedAt.toIso8601String(),
      publisherInformation: _topicPublisherInformationEntityMapper.from(data.publisherInformation),
      heroImage: _imageEntityMapper.from(data.heroImage),
      entries: data.entries.map((e) => _topicEntryEntityMapper.from(e)).toList(),
      visited: data.visited,
      category: _categoryEntityMapper.from(data.category),
    );
  }

  @override
  Topic to(TopicEntity data) {
    return Topic(
      id: data.id,
      slug: data.slug,
      title: data.title,
      strippedTitle: data.strippedTitle,
      introduction: data.introduction,
      ownersNote: data.ownersNote,
      url: data.url,
      curationInfo: _curationInfoEntityMapper.to(data.curationInfo),
      summary: data.summary,
      lastUpdatedAt: DateTime.parse(data.lastUpdatedAt),
      publisherInformation: _topicPublisherInformationEntityMapper.to(data.publisherInformation),
      heroImage: _imageEntityMapper.to(data.heroImage),
      entries: data.entries.map((e) => _topicEntryEntityMapper.to(e)).toList(),
      visited: data.visited,
      category: _categoryEntityMapper.to(data.category),
    );
  }
}
