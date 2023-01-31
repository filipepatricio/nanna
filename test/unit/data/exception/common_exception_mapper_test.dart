import 'package:better_informed_mobile/data/exception/common_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/exception/exception_mapper_facade.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/exception/server_error_exception.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  late ExceptionMapperFacade facade;

  setUp(() {
    facade = CommonExceptionMapper();
  });

  test('throws unwrapped exception from UnknownException', () {
    final originalException = NoInternetConnectionException();
    final exception = OperationException(
      linkException: UnknownException(
        originalException,
        StackTrace.fromString('Exception line 101'),
      ),
    );

    try {
      facade.mapAndThrow(exception);
      fail('It should have thrown error');
    } catch (e) {
      expect(e, originalException);
    }
  });

  test('throws NoInternetConnectionException for ServerException', () {
    final exception = OperationException(
      linkException: const ServerException(),
    );

    try {
      facade.mapAndThrow(exception);
      fail('It should have thrown error');
    } catch (e) {
      expect(e, isA<NoInternetConnectionException>());
    }
  });

  test('throws UnauthorizedException for graphql UNAUTHENTICATED error code', () {
    final exception = OperationException(
      graphqlErrors: [
        const GraphQLError(
          message: 'Some other error',
        ),
        const GraphQLError(
          message: 'This is UNAUTHENTICATED error message',
          extensions: {
            'code': 'UNAUTHENTICATED',
          },
        ),
      ],
    );

    try {
      facade.mapAndThrow(exception);
      fail('It should have thrown error');
    } catch (e) {
      expect(e, isA<UnauthorizedException>());
    }
  });

  test('throws ServerErrorException for ResponseFormatException with html body', () {
    final exception = OperationException(
      linkException: const ResponseFormatException(
        originalException: FormatException(
          '<html><body></body></html>',
        ),
      ),
    );

    try {
      facade.mapAndThrow(exception);
      fail('It should have thrown error');
    } catch (e) {
      expect(
        e,
        isA<ServerErrorException>().having(
          (serverErrorException) => serverErrorException.originalException,
          'originalException',
          exception,
        ),
      );
    }
  });
}
