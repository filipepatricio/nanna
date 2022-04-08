import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_exception.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const _noMemberAccessErrorCode = 'no_beta_access';

@LazySingleton(as: AuthApiDataSource)
class AuthGraphqlDataSource implements AuthApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  AuthGraphqlDataSource(@Named('unauthorized') this._client, this._responseResolver);

  @override
  Future<LoginResponseDTO> signInWithProvider(String token, String provider, [UserMetaDTO? userMeta]) async {
    final result = await _client.mutate(
      MutationOptions(
        document: AuthGQL.login(),
        variables: {
          'token': token,
          'provider': provider,
          'meta': userMeta ?? <String, dynamic>{},
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    return _processSignInResponse(result, SignInCredentials(provider: provider, token: token, userMeta: userMeta));
  }

  @override
  Future<LoginResponseDTO> signInWithInviteCode(
    SignInCredentials credentials,
    String code,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: AuthGQL.loginWithCode(),
        variables: {
          'token': credentials.token,
          'provider': credentials.provider,
          'meta': credentials.userMeta ?? <String, dynamic>{},
          'code': code,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    return _processSignInResponse(result, credentials);
  }

  @override
  Future<void> sendMagicLink(String email) async {
    final result = await _client.mutate(
      MutationOptions(
        document: AuthGQL.sendLink(email),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    _responseResolver.resolve(result, (raw) => null, rootKey: null);
  }

  LoginResponseDTO _processSignInResponse(QueryResult result, SignInCredentials credentials) {
    final response = _responseResolver.resolve(
      result,
      (raw) => LoginResponseDTO.fromJson(raw),
      rootKey: 'signIn',
    );

    if (response == null) throw Exception('Sign in failed.');
    if (response.successful != true) throw _resolveSignInError(response.errorCode, credentials);

    final tokens = response.tokens;
    if (tokens == null) throw Exception('Sign in did not return auth tokens.');

    return response;
  }

  Object _resolveSignInError(String? errorCode, SignInCredentials credentials) {
    if (errorCode == _noMemberAccessErrorCode) {
      return AuthException.noMemberAccess(credentials);
    }

    return AuthException.unknown();
  }
}
