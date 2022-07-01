import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';

class OAuthProviderTokenDTO {
  OAuthProviderTokenDTO(this.provider, this.token, this.userMeta);
  final String provider;
  final String token;
  final UserMetaDTO? userMeta;
}
