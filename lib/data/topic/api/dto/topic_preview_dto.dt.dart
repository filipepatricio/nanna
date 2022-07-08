import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_preview_dto.dt.g.dart';

@JsonSerializable()
class TopicPreviewDTO {
  TopicPreviewDTO(
    this.id,
    this.slug,
    this.title,
    this.strippedTitle,
    this.introduction,
    this.url,
    this.owner,
    this.lastUpdatedAt,
    this.highlightedPublishers,
    this.heroImage,
    this.entryCount,
    this.visited,
  );

  factory TopicPreviewDTO.fromJson(Map<String, dynamic> json) => _$TopicPreviewDTOFromJson(json);
  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String url;
  final TopicOwnerDTO owner;
  final String lastUpdatedAt;
  final List<PublisherDTO> highlightedPublishers;
  final ImageDTO heroImage;
  final int entryCount;
  final bool visited;

  Map<String, dynamic> toJson() => _$TopicPreviewDTOToJson(this);
}
