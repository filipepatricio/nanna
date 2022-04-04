import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';

abstract class AuthApiDataSource {
  Future<LoginResponseDTO> signInWithInviteCode(SignInCredentials credentials, String code);

  Future<LoginResponseDTO> signInWithProvider(String token, String provider, [UserMetaDTO? userMeta]);

  Future<void> sendMagicLink(String email);
}
