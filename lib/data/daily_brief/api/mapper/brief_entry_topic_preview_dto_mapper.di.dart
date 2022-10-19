import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryTopicPreviewDTOMapper implements Mapper<BriefEntryItemDTO, TopicPreview?> {
  BriefEntryTopicPreviewDTOMapper(
    this._topicOwnerDTOMapper,
    this._topicPublisherInformationDTOMapper,
    this._imageDTOMapper,
    this._categoryDTOMapper,
  );

  final TopicOwnerDTOMapper _topicOwnerDTOMapper;
  final TopicPublisherInformationDTOMapper _topicPublisherInformationDTOMapper;
  final ImageDTOMapper _imageDTOMapper;
  final CategoryDTOMapper _categoryDTOMapper;

  @override
  TopicPreview? call(BriefEntryItemDTO data) {
    return data.map(
      topicPreview: (data) => TopicPreview(
        data.id,
        data.slug,
        data.title,
        data.strippedTitle,
        data.introduction,
        data.url,
        _topicOwnerDTOMapper(data.owner),
        DateTime.parse(data.lastUpdatedAt).toLocal(),
        _topicPublisherInformationDTOMapper(data.publisherInformation),
        _imageDTOMapper(data.heroImage),
        data.entryCount,
        data.visited,
        _categoryDTOMapper(data.category),
      ),
      article: (_) => null,
      unknown: (_) => null,
    );
  }
}
