import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/data/auth/api/dto/user_meta_dto.dart';

abstract class AuthApiDataSource {
  Future<AuthTokenDTO> signInWithProvider(String token, String provider, [UserMetaDTO? userMeta]);

  Future<void> sendMagicLink(String email);
}
