// ignore_for_file: invalid_annotation_target

import 'package:better_informed_mobile/data/article/api/dto/article_kind_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_entry_item_dto.dt.freezed.dart';
part 'brief_entry_item_dto.dt.g.dart';

@Freezed(unionKey: '__typename', unionValueCase: FreezedUnionCase.pascal, fallbackUnion: unknownKey)
class BriefEntryItemDTO with _$BriefEntryItemDTO {
  @FreezedUnionValue('Article')
  const factory BriefEntryItemDTO.article(
    String id,
    String slug,
    String url,
    String title,
    String strippedTitle,
    String? note,
    String credits,
    String type,
    ArticleKindDTO? kind,
    String? publicationDate,
    int? timeToRead,
    PublisherDTO publisher,
    @JsonKey(name: 'articleImage') ArticleImageDTO? image,
    String sourceUrl,
    String? author,
    bool hasAudioVersion,
  ) = BriefEntryItemDTOArticle;

  @FreezedUnionValue('Topic')
  const factory BriefEntryItemDTO.topicPreview(
    String id,
    String slug,
    String title,
    String strippedTitle,
    String introduction,
    String url,
    TopicOwnerDTO owner,
    String lastUpdatedAt,
    List<PublisherDTO> highlightedPublishers,
    ImageDTO heroImage,
    int entryCount,
  ) = BriefEntryItemDTOTopic;

  @FreezedUnionValue(unknownKey)
  factory BriefEntryItemDTO.unknown() = _BriefEntryItemDTOUnknown;

  factory BriefEntryItemDTO.fromJson(Map<String, dynamic> json) => _$BriefEntryItemDTOFromJson(json);
}
