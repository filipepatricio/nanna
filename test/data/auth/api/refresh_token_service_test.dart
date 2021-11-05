import 'dart:async';

import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_response_dto.dart';
import 'package:better_informed_mobile/data/auth/api/refresh_token_service.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refresh_token_service_test.mocks.dart';

@GenerateMocks(
  [
    GraphQLClient,
    GraphQLResponseResolver,
    AuthTokenResponseDTO,
  ],
)
void main() {
  late MockGraphQLClient graphQLClient;
  late MockGraphQLResponseResolver resolver;
  late RefreshTokenService service;

  setUp(() {
    graphQLClient = MockGraphQLClient();
    resolver = MockGraphQLResponseResolver();
    service = RefreshTokenService(graphQLClient, resolver);
  });

  group('refreshToken', () {
    test('returns oauth tokens on success', () async {
      const accessToken = 'abcd1234';
      const refreshToken = 'bcda4321';
      final dto = AuthTokenResponseDTO(
        true,
        null,
        AuthTokenDTO(
          accessToken,
          refreshToken,
        ),
      );
      final result = QueryResult(
        source: QueryResultSource.network,
        data: {
          'refresh': {
            'successful': true,
            'tokens': {
              'accessToken': accessToken,
              'refreshToken': refreshToken,
            }
          }
        },
      );

      when(resolver.resolve(any, any, rootKey: anyNamed('rootKey'))).thenAnswer((realInvocation) => dto);
      when(graphQLClient.mutate(any)).thenAnswer((realInvocation) async => result);

      final actual = await service.refreshToken('someToken');

      expect(actual.accessToken, accessToken);
      expect(actual.refreshToken, refreshToken);
    });

    test('throws [RevokeTokenException] when tokens in response are [null]', () async {
      final dto = AuthTokenResponseDTO(
        true,
        null,
        null,
      );
      final result = QueryResult(
        source: QueryResultSource.network,
        data: {
          'refresh': {
            'successful': true,
            'tokens': null,
          }
        },
      );

      when(resolver.resolve(any, any, rootKey: anyNamed('rootKey'))).thenAnswer((realInvocation) => dto);
      when(graphQLClient.mutate(any)).thenAnswer((realInvocation) async => result);

      expect(
        service.refreshToken('someToken'),
        throwsA(
          isA<RevokeTokenException>(),
        ),
      );
    });

    test('throws [OperationException] when result has [OperationException]', () async {
      final exception = OperationException();
      final result = QueryResult(
        exception: exception,
        source: QueryResultSource.network,
        data: {
          'refresh': {
            'successful': true,
            'tokens': null,
          }
        },
      );

      when(resolver.resolve(any, any, rootKey: anyNamed('rootKey'))).thenAnswer((realInvocation) => throw exception);
      when(graphQLClient.mutate(any)).thenAnswer((realInvocation) async => result);

      expect(
        service.refreshToken('someToken'),
        throwsA(
          isA<OperationException>(),
        ),
      );
    });

    test('simultaneous calls will not resolve in concurrent token refresh', () async {
      const accessToken = 'abcd1234';
      const refreshToken = 'bcda4321';
      final dto = AuthTokenResponseDTO(
        true,
        null,
        AuthTokenDTO(
          accessToken,
          refreshToken,
        ),
      );
      final result = QueryResult(
        source: QueryResultSource.network,
        data: {
          'refresh': {
            'successful': true,
            'tokens': {
              'accessToken': accessToken,
              'refreshToken': refreshToken,
            }
          }
        },
      );
      final resultCompleter = Completer<QueryResult>();

      when(resolver.resolve(any, any, rootKey: anyNamed('rootKey'))).thenAnswer((realInvocation) => dto);
      when(graphQLClient.mutate(any)).thenAnswer((realInvocation) => resultCompleter.future);

      final simultaneousCalls = [
        service.refreshToken('someToken'),
        service.refreshToken('someToken'),
        service.refreshToken('someToken'),
        service.refreshToken('someToken'),
      ];

      resultCompleter.complete(result);

      await expectLater(
        Stream.fromFutures(simultaneousCalls),
        emitsThrough(
          isA<OAuth2Token>()
              .having(
                (token) => token.refreshToken,
                'refreshToken',
                refreshToken,
              )
              .having(
                (token) => token.accessToken,
                'accessToken',
                accessToken,
              ),
        ),
      );

      verify(graphQLClient.mutate(any)).called(1);
    });
  });
}
