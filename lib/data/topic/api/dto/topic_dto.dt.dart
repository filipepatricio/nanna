import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/curator_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/summary_card_dto.dt.dart';
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
    this.url,
    this.owner,
    this.lastUpdatedAt,
    this.publisherInformation,
    this.heroImage,
    this.entries,
    this.summaryCards,
    this.visited,
    this.category,
  );

  factory TopicDTO.fromJson(Map<String, dynamic> json) => _$TopicDTOFromJson(json);

  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String url;
  final CuratorDTO owner;
  final String lastUpdatedAt;
  final TopicPublisherInformationDTO publisherInformation;
  final ImageDTO heroImage;
  final List<EntryDTO> entries;
  final List<SummaryCardDTO> summaryCards;
  final bool visited;
  @JsonKey(name: 'primaryCategory')
  final CategoryDTO category;
}
