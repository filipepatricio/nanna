import 'package:better_informed_mobile/data/auth/api/dto/oauth_usermeta_credentials_dto.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/auth/api/dto/user_meta_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleCredentialDataSource implements OAuthCredentialProviderDataSource {
  @override
  String get provider => SignInProviderDTO.apple;

  @override
  Future<OAuthUserMetaCredentialsDTO> getUserMetaCredential() async {
    final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');

    final userMeta = UserMetaDTO(credentials.givenName, credentials.familyName);

    return OAuthUserMetaCredentialsDTO(userMeta, oAuthProvider.credential(
      idToken: credentials.identityToken,
      accessToken: credentials.authorizationCode,
    ));
  }
}
