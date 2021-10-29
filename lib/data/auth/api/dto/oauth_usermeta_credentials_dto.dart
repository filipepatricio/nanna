import 'package:better_informed_mobile/data/auth/api/dto/user_meta_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OAuthUserMetaCredentialsDTO {
  final UserMetaDTO userMeta;
  final OAuthCredential credentials;

  OAuthUserMetaCredentialsDTO(this.userMeta, this.credentials);
}
