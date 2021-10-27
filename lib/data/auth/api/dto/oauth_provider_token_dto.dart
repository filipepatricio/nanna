import 'package:better_informed_mobile/domain/user/data/user_meta.dart';

class OAuthProviderTokenDTO {
  final String provider;
  final String token;
  final UserMeta? userMeta;

  OAuthProviderTokenDTO(this.provider, this.token, this.userMeta);
}
