import 'dart:async';

import 'package:better_informed_mobile/data/auth/api/documents/__generated__/refresh.ast.gql.dart' as refresh;
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_response_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RefreshTokenService {
  RefreshTokenService(
    @Named('unauthorized') this._unauthorizedClient,
    this._responseResolver,
    this._refreshTokenServiceCache,
  );
  final GraphQLClient _unauthorizedClient;
  final GraphQLResponseResolver _responseResolver;
  final RefreshTokenServiceCache _refreshTokenServiceCache;

  Completer<OAuth2Token>? _lockCompleter;

  Future<OAuth2Token> refreshToken(String refreshToken) async {
    final lock = _lockCompleter;
    if (lock != null && !lock.isCompleted) {
      return lock.future;
    }

    final lastToken = _refreshTokenServiceCache.get();
    if (lastToken != null && lastToken.refreshToken != refreshToken) {
      return lastToken;
    }

    final newLock = Completer<OAuth2Token>();
    _lockCompleter = newLock;

    try {
      final result = await _unauthorizedClient.mutate(
        MutationOptions(
          document: refresh.document,
          operationName: refresh.refreshToken.name?.value,
          variables: {
            'token': refreshToken,
          },
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

      _refreshTokenServiceCache.set(oAuthToken);
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

@lazySingleton
class RefreshTokenServiceCache {
  OAuth2Token? _cachedToken;

  OAuth2Token? get() => _cachedToken;

  void set(OAuth2Token token) => _cachedToken = token;

  void clear() => _cachedToken = null;
}
