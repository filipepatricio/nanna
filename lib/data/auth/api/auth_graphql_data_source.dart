import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

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

    return _processSignInResponse(result);
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

  LoginResponseDTO _processSignInResponse(QueryResult result) {
    final response = _responseResolver.resolve(
      result,
      (raw) => LoginResponseDTO.fromJson(raw),
      rootKey: 'signIn',
    );

    if (response == null) throw Exception('Sign in failed.');
    if (response.successful != true) throw Exception('Sign in failed.');

    final tokens = response.tokens;
    if (tokens == null) throw Exception('Sign in did not return auth tokens.');

    return response;
  }
}
