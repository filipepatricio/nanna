import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OAuthUserMetaCredentialsDTO {
  final UserMetaDTO userMetaDto;
  final OAuthCredential credentials;

  OAuthUserMetaCredentialsDTO(this.userMetaDto, this.credentials);
}
