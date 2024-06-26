import 'package:json_annotation/json_annotation.dart';

part 'linked_in_user.dt.g.dart';

@JsonSerializable(createToJson: false)
class LinkedinUserDTO {
  LinkedinUserDTO(
    this.firstName,
    this.lastName,
  );

  factory LinkedinUserDTO.fromJson(Map<String, dynamic> json) => _$LinkedinUserDTOFromJson(json);

  @JsonKey(name: 'localizedFirstName')
  final String firstName;
  @JsonKey(name: 'localizedLastName')
  final String lastName;
}
