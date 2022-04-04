import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token_response_dto.dt.g.dart';

@JsonSerializable()
class AuthTokenResponseDTO {
  final bool successful;
  final String? errorMessage;
  final AuthTokenDTO? tokens;

  AuthTokenResponseDTO(
    this.successful,
    this.errorMessage,
    this.tokens,
  );

  factory AuthTokenResponseDTO.fromJson(Map<String, dynamic> json) => _$AuthTokenResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenResponseDTOToJson(this);
}
