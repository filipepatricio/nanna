import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthApiDataSource, env: mockEnvs)
class AuthMockDataSource implements AuthApiDataSource {
  @override
  Future<LoginResponseDTO> signInWithProvider(String token, String provider, [UserMetaDTO? userMeta]) async {
    throw UnimplementedError();
  }

  @override
  Future<LoginResponseDTO> signInWithInviteCode(
    SignInCredentials credentials,
    String code,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMagicLink(String email) async {
    return;
  }
}
