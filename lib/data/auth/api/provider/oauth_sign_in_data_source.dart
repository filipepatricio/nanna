import 'package:better_informed_mobile/data/auth/api/dto/oauth_provider_token_dto.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OAuthSignInDataSource {
  final OAuthCredentialProviderDataSource _credentialProviderDataSource;

  OAuthSignInDataSource(this._credentialProviderDataSource);

  Future<OAuthProviderTokenDTO> getProviderToken() async {
    final credential = await _credentialProviderDataSource.getCredential();
    final provider = _credentialProviderDataSource.provider;

    final token = credential.idToken;
    if (token == null) throw Exception('OAuth token is null');

    return OAuthProviderTokenDTO(provider, token);
  }
}
