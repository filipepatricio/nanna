import 'dart:io';

import 'package:better_informed_mobile/data/auth/api/dto/oauth_usermeta_credentials_dto.dart';
import 'package:better_informed_mobile/data/auth/api/provider/apple_credential_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/google_credential_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

abstract class OAuthCredentialProviderDataSource {
  String get provider;

  Future<OAuthUserMetaCredentialsDTO> getUserMetaCredential();
}

@injectable
class OAuthCredentialProviderDataSourceFactory {
  OAuthCredentialProviderDataSource create() {
    if (Platform.isAndroid) {
      return GoogleCredentialDataSource();
    } else if (Platform.isIOS) {
      return AppleCredentialDataSource();
    }

    throw Exception('Unhandled platform: ${Platform.operatingSystem}.');
  }
}
