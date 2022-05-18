import 'package:json_annotation/json_annotation.dart';

part 'linked_in_user.dt.g.dart';

@JsonSerializable()
class LinkedinUserDTO {
  LinkedinUserDTO(
    this.firstName,
    this.lastName,
  );

  @JsonKey(name: 'localizedFirstName')
  final String firstName;
  @JsonKey(name: 'localizedLastName')
  final String lastName;

  factory LinkedinUserDTO.fromJson(Map<String, dynamic> json) => _$LinkedinUserDTOFromJson(json);
}
