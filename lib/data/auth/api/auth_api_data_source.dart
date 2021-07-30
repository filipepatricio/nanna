import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthApiDataSource {
  final GraphQLClient _client;

  AuthApiDataSource(this._client);

  Future<QueryResult> signInWithProvider(String token, String provider) async {
    return _client.mutate(
      MutationOptions(
        document: AuthGQL.login(token, provider),
      ),
    );
  }
}
