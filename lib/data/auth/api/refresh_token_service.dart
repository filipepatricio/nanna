import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RefreshTokenService {
  final GraphQLClient _unauthorizedClient;

  RefreshTokenService(@Named('unauthorized') this._unauthorizedClient);

  Future<OAuth2Token> refreshToken(String refreshToken) async {
    final result = await _unauthorizedClient.mutate(
      MutationOptions(
        document: AuthGQL.refresh(refreshToken),
      ),
    );

    if (result.hasException) throw Exception('Refresh token failed');

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => AuthTokenDTO.fromJson(raw),
      innerKey: 'refresh',
    );

    if (dto == null) throw Exception('New token is null');

    return OAuth2Token(accessToken: dto.accessToken, refreshToken: dto.refreshToken);
  }
}
