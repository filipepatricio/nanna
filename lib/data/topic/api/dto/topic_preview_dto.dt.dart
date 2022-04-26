import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_preview_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_preview_dto.dt.g.dart';

@JsonSerializable()
class TopicPreviewDTO {
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
  final ImageDTO coverImage;
  final ReadingListPreviewDTO readingList;

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
    this.coverImage,
    this.readingList,
  );

  factory TopicPreviewDTO.fromJson(Map<String, dynamic> json) => _$TopicPreviewDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicPreviewDTOToJson(this);
}