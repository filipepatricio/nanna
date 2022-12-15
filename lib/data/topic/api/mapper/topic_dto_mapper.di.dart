import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/common/mapper/curation_info_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicDTOMapper implements Mapper<TopicDTO, Topic> {
  TopicDTOMapper(
    this._imageDTOMapper,
    this._entryDTOMapper,
    this._topicPublisherInformationDTOMapper,
    this._categoryDTOMapper,
    this._curationInfoDTOMapper,
  );

  final ImageDTOMapper _imageDTOMapper;
  final EntryDTOMapper _entryDTOMapper;
  final TopicPublisherInformationDTOMapper _topicPublisherInformationDTOMapper;
  final CategoryDTOMapper _categoryDTOMapper;
  final CurationInfoDTOMapper _curationInfoDTOMapper;

  @override
  Topic call(TopicDTO data) {
    return Topic(
      id: data.id,
      slug: data.slug,
      title: data.title,
      strippedTitle: data.strippedTitle,
      introduction: data.introduction,
      ownersNote: data.ownersNote,
      url: data.url,
      curationInfo: _curationInfoDTOMapper(data.curationInfo),
      lastUpdatedAt: DateTime.parse(data.lastUpdatedAt).toLocal(),
      publisherInformation: _topicPublisherInformationDTOMapper(data.publisherInformation),
      heroImage: _imageDTOMapper(data.heroImage),
      entries: data.entries.map<Entry>(_entryDTOMapper).toList(),
      summary: data.summary,
      visited: data.visited,
      category: _categoryDTOMapper(data.category),
    );
  }
}
