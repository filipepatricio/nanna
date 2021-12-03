import 'package:better_informed_mobile/data/auth/api/dto/oauth_user_meta_credentials_dto.dart';
import 'package:better_informed_mobile/data/auth/api/provider/apple_credential_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/google_credential_data_source.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

abstract class OAuthCredentialProviderDataSource {
  String get provider;

  Future<OAuthUserMetaCredentialsDTO> getUserMetaCredential();
}

@injectable
class OAuthCredentialProviderDataSourceFactory {
  OAuthCredentialProviderDataSource create() {
    if (kIsAppleDevice) {
      return AppleCredentialDataSource();
    }
    return GoogleCredentialDataSource();
  }
}
