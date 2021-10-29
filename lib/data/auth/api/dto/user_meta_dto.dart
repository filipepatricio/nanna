import 'package:json_annotation/json_annotation.dart';
part 'user_meta_dto.g.dart';

@JsonSerializable()
class UserMetaDTO {
  final String? avatarUrl;
  final String? firstName;
  final String? lastName;

  UserMetaDTO(this.firstName, this.lastName, [this.avatarUrl = '']);

  factory UserMetaDTO.fromJson(Map<String, dynamic> json) => _$UserMetaDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserMetaDTOToJson(this);
}
