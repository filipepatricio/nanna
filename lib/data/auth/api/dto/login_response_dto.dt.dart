import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.dt.g.dart';

@JsonSerializable()
class LoginResponseDTO {
  LoginResponseDTO(
    this.successful,
    this.errorCode,
    this.errorMessage,
    this.tokens,
    this.account,
  );

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) => _$LoginResponseDTOFromJson(json);
  final bool successful;
  final String? errorCode;
  final String? errorMessage;
  final AuthTokenDTO? tokens;
  final UserDTO? account;

  Map<String, dynamic> toJson() => _$LoginResponseDTOToJson(this);
}
