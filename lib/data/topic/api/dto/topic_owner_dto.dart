import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_owner_dto.g.dart';
part 'topic_owner_dto.freezed.dart';

@Freezed(unionKey: '__typename')
class TopicOwnerDTO with _$TopicOwnerDTO {
  @FreezedUnionValue('Expert')
  factory TopicOwnerDTO.expert(String id, String name, String bio, ImageDTO? avatar) = _TopicOwnerDTOExpert;

  @FreezedUnionValue('Editor')
  factory TopicOwnerDTO.editor(String name, ImageDTO? avatar) = _TopicOwnerDTOEditor;

  factory TopicOwnerDTO.fromJson(Map<String, dynamic> json) => _$TopicOwnerDTOFromJson(json);
}
