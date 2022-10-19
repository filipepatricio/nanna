import 'package:json_annotation/json_annotation.dart';

part 'user_meta_dto.dt.g.dart';

@JsonSerializable()
class UserMetaDTO {
  UserMetaDTO(this.firstName, this.lastName, [this.avatarUrl = '']);

  factory UserMetaDTO.fromJson(Map<String, dynamic> json) => _$UserMetaDTOFromJson(json);

  final String? avatarUrl;
  final String? firstName;
  final String? lastName;

  Map<String, dynamic> toJson() => _$UserMetaDTOToJson(this);
}
