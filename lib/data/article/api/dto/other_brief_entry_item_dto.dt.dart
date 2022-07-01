import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'other_brief_entry_item_dto.dt.freezed.dart';
part 'other_brief_entry_item_dto.dt.g.dart';

@Freezed(unionKey: '__typename', unionValueCase: FreezedUnionCase.pascal, fallbackUnion: unknownKey)
class OtherBriefEntryItemDTO with _$OtherBriefEntryItemDTO {
  @FreezedUnionValue('Article')
  const factory OtherBriefEntryItemDTO.article(
    String id,
    String slug,
    String progressState,
  ) = OtherBriefEntryItemDTOArticle;

  @FreezedUnionValue('Topic')
  const factory OtherBriefEntryItemDTO.topicPreview(
    String id,
    String slug,
    bool visited,
  ) = OtherBriefEntryItemDTOTopic;

  @FreezedUnionValue(unknownKey)
  factory OtherBriefEntryItemDTO.unknown() = _OtherBriefEntryItemDTOUnknown;

  factory OtherBriefEntryItemDTO.fromJson(Map<String, dynamic> json) => _$OtherBriefEntryItemDTOFromJson(json);
}
