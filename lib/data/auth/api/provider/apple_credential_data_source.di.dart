import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@injectable
class AppleCredentialDataSource implements OAuthCredentialProviderDataSource {
  @override
  Future<OAuthUserDTO> fetchOAuthUser() async {
    try {
      final credentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final userMetaDto = UserMetaDTO(credentials.givenName, credentials.familyName);

      final token = credentials.identityToken;
      if (token == null) throw Exception('Apple sign in did not provide idToken');

      return OAuthUserDTO(
        user: userMetaDto,
        token: token,
        provider: SignInProviderDTO.apple,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) throw SignInAbortedException();
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
