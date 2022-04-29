import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicPreviewDTOMapper implements Mapper<TopicPreviewDTO, TopicPreview> {
  TopicPreviewDTOMapper(
    this._topicOwnerDTOMapper,
    this._publisherDTOMapper,
    this._imageDTOMapper,
  );

  final TopicOwnerDTOMapper _topicOwnerDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ImageDTOMapper _imageDTOMapper;

  @override
  TopicPreview call(TopicPreviewDTO data) {
    return TopicPreview(
      data.id,
      data.slug,
      data.title,
      data.strippedTitle,
      data.introduction,
      data.url,
      _topicOwnerDTOMapper(data.owner),
      DateTime.parse(data.lastUpdatedAt).toLocal(),
      data.highlightedPublishers.map((publisher) => _publisherDTOMapper(publisher)).toList(),
      _imageDTOMapper(data.heroImage),
      _imageDTOMapper(data.coverImage),
      data.entryCount,
    );
  }
}
