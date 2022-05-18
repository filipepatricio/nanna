import 'package:better_informed_mobile/data/auth/api/provider/apple_credential_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/google_credential_data_source.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

abstract class OAuthCredentialProviderDataSource {
  Future<OAuthUserDTO> fetchOAuthUser();
}

@injectable
class OAuthCredentialPlatformProviderDataSourceFactory {
  OAuthCredentialProviderDataSource create() {
    if (kIsAppleDevice) {
      return AppleCredentialDataSource();
    }
    return GoogleCredentialDataSource();
  }
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
