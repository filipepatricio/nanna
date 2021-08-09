import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleCredentialDataSource implements OAuthCredentialProviderDataSource {
  @override
  String get provider => SignInProviderDTO.apple;

  @override
  Future<OAuthCredential> getCredential() async {
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
