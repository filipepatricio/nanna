import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialDataSource implements OAuthCredentialProviderDataSource {
  @override
  Future<OAuthUserDTO> fetchOAuthUser() async {
    final googleSignIn = GoogleSignIn(scopes: ['email']);

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final account = await googleSignIn.signIn();

    if (account != null) {
      final userNameParts = account.displayName?.split(' ');
      final userMetaDto = UserMetaDTO(
        userNameParts?.first,
        userNameParts?.sublist(1).join(' '),
        account.photoUrl,
      );
      final auth = await account.authentication;

      final token = auth.idToken;
      if (token == null) throw Exception('Google sign in did not respond with idToken');

      return OAuthUserDTO(
        user: userMetaDto,
        token: token,
        provider: SignInProviderDTO.google,
      );
    }

    throw SignInAbortedException();
  }
}
