import 'package:better_informed_mobile/data/exception/unknown_exception_unwrap_mapper.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  late UnknownExceptionUnwrapMapper mapper;

  setUp(() {
    mapper = UnknownExceptionUnwrapMapper();
  });

  test('returns original exception for unknown exception', () {
    final originalException = NoInternetConnectionException();
    final unknownException = OperationException(
      linkException: UnknownException(
        originalException,
        StackTrace.fromString('Exception line 101'),
      ),
    );

    final isFitting = mapper.isFitting(unknownException);
    final mapped = mapper.map(unknownException);

    expect(isFitting, true);
    expect(mapped, originalException);
  });

  test('does nothing for other exception', () {
    const originalException = ServerException();
    final unknownException = OperationException(
      linkException: originalException,
    );

    final isFitting = mapper.isFitting(unknownException);

    expect(isFitting, false);
  });
}
