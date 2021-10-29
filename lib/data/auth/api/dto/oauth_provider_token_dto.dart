import 'package:better_informed_mobile/data/auth/api/dto/user_meta_dto.dart';

class OAuthProviderTokenDTO {
  final String provider;
  final String token;
  final UserMetaDTO? userMeta;

  OAuthProviderTokenDTO(this.provider, this.token, this.userMeta);
}
