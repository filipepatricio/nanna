import 'dart:async';

import 'package:better_informed_mobile/data/auth/api/auth_gql.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_response_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RefreshTokenService {
  final GraphQLClient _unauthorizedClient;
  final GraphQLResponseResolver _responseResolver;

  Completer<OAuth2Token>? _lockCompleter;

  RefreshTokenService(
    @Named('unauthorized') this._unauthorizedClient,
    this._responseResolver,
  );

  Future<OAuth2Token> refreshToken(String refreshToken) async {
    final lock = _lockCompleter;
    if (lock != null && !lock.isCompleted) {
      return lock.future;
    }

    final newLock = Completer<OAuth2Token>();
    _lockCompleter = newLock;

    try {
      final result = await _unauthorizedClient.mutate(
        MutationOptions(
          document: AuthGQL.refresh(refreshToken),
        ),
      );

      final dto = _responseResolver.resolve(
        result,
        (raw) => AuthTokenResponseDTO.fromJson(raw),
        rootKey: 'refresh',
      );

      final tokensDto = dto?.tokens;
      if (tokensDto == null) throw RevokeTokenException();

      final oAuthToken = OAuth2Token(
        accessToken: tokensDto.accessToken,
        refreshToken: tokensDto.refreshToken,
      );

      newLock.complete(oAuthToken);
      return oAuthToken;
    } catch (e, s) {
      runZonedGuarded(
        () => newLock.complete(Future.error(e, s)),
        (error, stack) {
          /// We have to catch this error, in case when there are no subscribers to Completer
          /// it would result in uncaught error
        },
      );
      rethrow;
    }
  }
}
