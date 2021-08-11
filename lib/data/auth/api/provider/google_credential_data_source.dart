import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialDataSource implements OAuthCredentialProviderDataSource {
  @override
  String get provider => SignInProviderDTO.google;

  @override
  Future<OAuthCredential> getCredential() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final account = await googleSignIn.signIn();

    if (account != null) {
      final auth = await account.authentication;
      return GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
    }

    throw Exception('Account was not received from google');
  }
}
