import 'package:better_informed_mobile/data/auth/api/provider/oauth_provider_sign_in_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInDataSource implements OAuthProviderSignInDataSource {
  @override
  String get provider => SignInProviderDTO.google;

  @override
  Future<OAuthCredential> signIn() async {
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
