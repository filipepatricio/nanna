import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_owner_dto.dt.freezed.dart';
part 'topic_owner_dto.dt.g.dart';

@Freezed(unionKey: '__typename', fallbackUnion: unknownKey, toJson: false)
class TopicOwnerDTO with _$TopicOwnerDTO {
  @FreezedUnionValue('Expert')
  factory TopicOwnerDTO.expert(
    String id,
    String name,
    String bio,
    String areaOfExpertise,
    String? instagram,
    String? linkedin,
    String? website,
    String? twitter,
    ImageDTO? avatar,
  ) = _TopicOwnerDTOExpert;

  @FreezedUnionValue('Editor')
  factory TopicOwnerDTO.editor(
    String id,
    String name,
    String bio,
    ImageDTO? avatar,
  ) = _TopicOwnerDTOEditor;

  @FreezedUnionValue('EditorialTeam')
  factory TopicOwnerDTO.editorialTeam(
    String name,
    String bio,
  ) = _TopicOwnerDTOEditorialTeam;

  @FreezedUnionValue(unknownKey)
  factory TopicOwnerDTO.unknown() = _TopicOwnerDTOUnknown;

  factory TopicOwnerDTO.fromJson(Map<String, dynamic> json) => _$TopicOwnerDTOFromJson(json);
}
