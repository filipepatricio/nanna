import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token_dto.dt.g.dart';

@JsonSerializable()
class AuthTokenDTO {
  AuthTokenDTO(this.accessToken, this.refreshToken);

  factory AuthTokenDTO.fromJson(Map<String, dynamic> json) => _$AuthTokenDTOFromJson(json);
  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$AuthTokenDTOToJson(this);
}
