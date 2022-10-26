import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'curator_dto.dt.freezed.dart';
part 'curator_dto.dt.g.dart';

@Freezed(unionKey: '__typename', fallbackUnion: unknownKey, toJson: false)
class CuratorDTO with _$CuratorDTO {
  @FreezedUnionValue('Expert')
  factory CuratorDTO.expert(
    String id,
    String name,
    String bio,
    String areaOfExpertise,
    String? instagram,
    String? linkedin,
    String? website,
    String? twitter,
    ImageDTO? avatar,
  ) = _CuratorDTOExpert;

  @FreezedUnionValue('Editor')
  factory CuratorDTO.editor(
    String id,
    String name,
    String bio,
    ImageDTO? avatar,
  ) = _CuratorDTOEditor;

  @FreezedUnionValue('EditorialTeam')
  factory CuratorDTO.editorialTeam(
    String name,
    String bio,
  ) = _CuratorDTOEditorialTeam;

  @FreezedUnionValue(unknownKey)
  factory CuratorDTO.unknown() = _CuratorDTOUnknown;

  factory CuratorDTO.fromJson(Map<String, dynamic> json) => _$CuratorDTOFromJson(json);
}
