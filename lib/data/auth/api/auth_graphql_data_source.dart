import 'dart:convert';

import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthApiDataSource)
class AuthGraphqlDataSource implements AuthApiDataSource {
  final GraphQLClient _client;

  AuthGraphqlDataSource(@Named('unauthorized') this._client);

  @override
  Future<LoginResponseDTO> signInWithProvider(String token, String provider, [UserMetaDTO? userMeta]) async {
    final result = await _client.mutate(
      MutationOptions(
        document: AuthGQL.login(),
        variables: {
          'token': token,
          'provider': provider,
          'meta': userMeta
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
    GraphQLResponseResolver.resolve(result, (raw) => null, rootKey: null);
  }

  LoginResponseDTO _processSignInResponse(QueryResult result) {
    final response = GraphQLResponseResolver.resolve(
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
