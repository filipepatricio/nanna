import 'package:json_annotation/json_annotation.dart';

part 'user_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class UserDTO {
  UserDTO(this.uuid, this.firstName, this.lastName, this.email);

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
  final String uuid;
  final String? firstName;
  final String? lastName;
  final String email;
}
