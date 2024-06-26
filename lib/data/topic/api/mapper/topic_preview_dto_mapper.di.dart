import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/common/mapper/curation_info_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicPreviewDTOMapper implements Mapper<TopicPreviewDTO, TopicPreview> {
  TopicPreviewDTOMapper(
    this._topicPublisherInformationDTOMapper,
    this._imageDTOMapper,
    this._categoryDTOMapper,
    this._curationInfoDTOMapper,
  );

  final TopicPublisherInformationDTOMapper _topicPublisherInformationDTOMapper;
  final ImageDTOMapper _imageDTOMapper;
  final CategoryDTOMapper _categoryDTOMapper;
  final CurationInfoDTOMapper _curationInfoDTOMapper;

  @override
  TopicPreview call(TopicPreviewDTO data) {
    return TopicPreview(
      data.id,
      data.slug,
      data.title,
      data.strippedTitle,
      data.introduction,
      data.ownersNote,
      data.url,
      _curationInfoDTOMapper(data.curationInfo),
      DateTime.parse(data.lastUpdatedAt).toLocal(),
      _topicPublisherInformationDTOMapper(data.publisherInformation),
      _imageDTOMapper(data.heroImage),
      data.entryCount,
      data.visited,
      _categoryDTOMapper(data.category),
    );
  }
}
