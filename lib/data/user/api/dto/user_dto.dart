import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDTO {
  final String uuid;
  final String? firstName;
  final String? lastName;
  final String email;

  UserDTO(this.uuid, this.firstName, this.lastName, this.email);

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}
