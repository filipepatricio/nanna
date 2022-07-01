import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_data_dto.dt.g.dart';

@JsonSerializable()
class TokenDataDTO {
  TokenDataDTO(this.uuid, this.email, this.firstName, this.lastName);

  factory TokenDataDTO.fromJson(Map<String, dynamic> json) => _$TokenDataDTOFromJson(json);
  @JsonKey(name: 'sub')
  final String uuid;
  final String? email;
  @JsonKey(name: 'given_name')
  final String? firstName;
  @JsonKey(name: 'family_name')
  final String? lastName;
}
