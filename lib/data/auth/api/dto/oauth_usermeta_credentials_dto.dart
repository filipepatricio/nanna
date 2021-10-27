import 'package:better_informed_mobile/domain/user/data/user_meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OAuthUserMetaCredentialsDTO {
  final UserMeta userMeta;
  final OAuthCredential credentials;

  OAuthUserMetaCredentialsDTO(this.userMeta, this.credentials);
}
