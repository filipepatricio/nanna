import 'package:better_informed_mobile/data/auth/api/dto/oauth_user_meta_credentials_dto.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialDataSource implements OAuthCredentialProviderDataSource {
  @override
  String get provider => SignInProviderDTO.google;

  @override
  Future<OAuthUserMetaCredentialsDTO> getUserMetaCredential() async {
    final googleSignIn = GoogleSignIn(scopes: ['email']);

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final account = await googleSignIn.signIn();

    if (account != null) {
      final userNameParts = account.displayName?.split(' ');
      final userMetaDto = UserMetaDTO(userNameParts?.first, userNameParts?.sublist(1).join(' '), account.photoUrl);
      final auth = await account.authentication;
      return OAuthUserMetaCredentialsDTO(
        userMetaDto,
        GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        ),
      );
    }

    throw SignInAbortedException();
  }
}
