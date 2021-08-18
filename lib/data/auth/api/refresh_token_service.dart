import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_response_dto.dart';
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

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => AuthTokenResponseDTO.fromJson(raw),
      rootKey: 'refresh',
    );

    final tokensDto = dto?.tokens;
    if (tokensDto == null) throw RevokeTokenException();

    return OAuth2Token(
      accessToken: tokensDto.accessToken,
      refreshToken: tokensDto.refreshToken,
    );
  }
}
