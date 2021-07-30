import 'package:better_informed_mobile/data/auth/api/provider/oauth_provider_sign_in_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInDataSource implements OAuthProviderSignInDataSource {
  @override
  String get provider => SignInProviderDTO.apple;

  @override
  Future<OAuthCredential> signIn() async {
    final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');

    return oAuthProvider.credential(
      idToken: credentials.identityToken,
      accessToken: credentials.authorizationCode,
    );
  }
}
