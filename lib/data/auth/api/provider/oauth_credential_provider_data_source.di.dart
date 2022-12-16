import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';

abstract class OAuthCredentialProviderDataSource {
  Future<OAuthUserDTO> fetchOAuthUser();
}

class OAuthUserDTO {
  OAuthUserDTO({
    required this.user,
    required this.token,
    required this.provider,
  });

  final UserMetaDTO user;
  final String token;
  final String provider;
}
