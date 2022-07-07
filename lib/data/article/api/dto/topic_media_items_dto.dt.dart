import 'package:better_informed_mobile/data/daily_brief/api/dto/media_item_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_media_items_dto.dt.g.dart';

@JsonSerializable()
class TopicMediaItemsDTO {
  TopicMediaItemsDTO(this.getOtherTopicEntries);

  factory TopicMediaItemsDTO.fromJson(Map<String, dynamic> json) {
    return _$TopicMediaItemsDTOFromJson(json);
  }

  final List<MediaItemDTO> getOtherTopicEntries;
}
