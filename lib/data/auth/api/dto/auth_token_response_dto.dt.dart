import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class AuthTokenResponseDTO {
  AuthTokenResponseDTO(
    this.successful,
    this.errorMessage,
    this.tokens,
  );

  factory AuthTokenResponseDTO.fromJson(Map<String, dynamic> json) => _$AuthTokenResponseDTOFromJson(json);
  final bool successful;
  final String? errorMessage;
  final AuthTokenDTO? tokens;
}
