import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_user_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2_client/linkedin_oauth2_client.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

@injectable
class LinkedinCredentialDataSource implements OAuthCredentialProviderDataSource {
  LinkedinCredentialDataSource(
    this._linkedinUserDataSource,
    this.appConfig,
  );

  final LinkedinUserDataSource _linkedinUserDataSource;
  final AppConfig appConfig;

  @override
  Future<OAuthUserDTO> fetchOAuthUser() async {
    final linkedinClient = LinkedInOAuth2Client(
      redirectUri: appConfig.linkedinConfig.redirectUri,
      customUriScheme: 'https',
    );
    linkedinClient.credentialsLocation = CredentialsLocation.BODY;
    final oauthHelper = OAuth2Helper(
      linkedinClient,
      clientId: appConfig.linkedinConfig.clientId,
      clientSecret: appConfig.linkedinConfig.clientSecret,
      scopes: [
        'r_emailaddress',
        'r_liteprofile',
      ],
    );

    try {
      final token = await oauthHelper.fetchToken();

      final accessToken = token.accessToken;
      if (accessToken == null) throw Exception('Linkedin did not provide access token');

      final user = await _linkedinUserDataSource.getUser(accessToken);

      return OAuthUserDTO(
        user: UserMetaDTO(
          user.firstName,
          user.lastName,
        ),
        token: accessToken,
        provider: SignInProviderDTO.linkedin,
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        throw SignInAbortedException();
      }
      rethrow;
    }
  }
}
