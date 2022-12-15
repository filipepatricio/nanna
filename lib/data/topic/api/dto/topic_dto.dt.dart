import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_publisher_information_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class TopicDTO {
  const TopicDTO(
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
    this.entries,
    this.summary,
    this.visited,
    this.category,
  );

  factory TopicDTO.fromJson(Map<String, dynamic> json) => _$TopicDTOFromJson(json);

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
  final List<EntryDTO> entries;
  final String? summary;
  final bool visited;
  @JsonKey(name: 'primaryCategory')
  final CategoryDTO category;
}
