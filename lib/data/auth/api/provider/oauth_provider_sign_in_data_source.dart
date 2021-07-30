import 'package:firebase_auth/firebase_auth.dart';

abstract class OAuthProviderSignInDataSource {
  String get provider;

  Future<OAuthCredential> signIn();
}
