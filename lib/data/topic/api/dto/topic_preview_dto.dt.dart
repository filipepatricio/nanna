import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_publisher_information_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_preview_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class TopicPreviewDTO {
  const TopicPreviewDTO(
    this.id,
    this.slug,
    this.title,
    this.strippedTitle,
    this.introduction,
    this.ownersNote,
    this.url,
    this.curationInfo,
    this.lastUpdatedAt,
    this.publisherInformation,
    this.heroImage,
    this.entryCount,
    this.visited,
    this.category,
  );

  factory TopicPreviewDTO.fromJson(Map<String, dynamic> json) => _$TopicPreviewDTOFromJson(json);

  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String? ownersNote;
  final String url;
  final CurationInfoDTO curationInfo;
  final String lastUpdatedAt;
  final TopicPublisherInformationDTO publisherInformation;
  final ImageDTO heroImage;
  final int entryCount;
  final bool visited;
  @JsonKey(name: 'primaryCategory')
  final CategoryDTO category;
}
