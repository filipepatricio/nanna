import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/user/api/mapper/user_dto_mapper.dart';
import 'package:better_informed_mobile/domain/auth/data/login_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginResponseDTOMapper implements Mapper<LoginResponseDTO, LoginResponse> {
  final AuthTokenDTOMapper _authTokenDTOMapper;
  final UserDTOMapper _userDTOMapper;

  LoginResponseDTOMapper(this._authTokenDTOMapper, this._userDTOMapper);

  @override
  LoginResponse call(LoginResponseDTO data) {
    return LoginResponse(
      _authTokenDTOMapper.from(data.tokens!),
      _userDTOMapper.to(data.account),
    );
  }
}
