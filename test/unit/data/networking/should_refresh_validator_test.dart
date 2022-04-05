import 'package:better_informed_mobile/data/networking/should_refresh_validator.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  late ShouldRefreshValidator validator;

  setUp(() {
    validator = ShouldRefreshValidator();
  });

  test('returns false when response has [null] errors', () async {
    const response = Response(errors: null);

    expect(validator(response), false);
  });

  test('returns false when response has empty error list', () async {
    const response = Response(errors: []);

    expect(validator(response), false);
  });

  test(
    'returns true when response has error extension containing only entry [$unauthenticatedErrorKey] : [$unauthenticatedErrorValue]',
    () async {
      const response = Response(
        errors: [
          GraphQLError(
            message: 'message',
            extensions: {
              unauthenticatedErrorKey: unauthenticatedErrorValue,
            },
          ),
        ],
      );

      expect(validator(response), true);
    },
  );

  test(
    'returns true when response has error extension containing entry [$unauthenticatedErrorKey] : [$unauthenticatedErrorValue]',
    () async {
      const response = Response(
        errors: [
          GraphQLError(
            message: 'message',
            extensions: {
              unauthenticatedErrorKey: unauthenticatedErrorValue,
              'differentCode': 'differentValue',
            },
          ),
        ],
      );

      expect(validator(response), true);
    },
  );

  test(
    'returns true when response has multiple errors, one of them with extension containing entry [$unauthenticatedErrorKey] : [$unauthenticatedErrorValue]',
    () async {
      const response = Response(
        errors: [
          GraphQLError(
            message: 'message',
            extensions: {
              unauthenticatedErrorKey: unauthenticatedErrorValue,
            },
          ),
          GraphQLError(
            message: 'message',
            extensions: {
              'differentCode': 'differentValue',
            },
          ),
          GraphQLError(
            message: 'message',
            extensions: {
              'differentCode': 'differentValue',
            },
          ),
        ],
      );

      expect(validator(response), true);
    },
  );

  test(
    'returns false when response has error has no extension entry [$unauthenticatedErrorKey] : [$unauthenticatedErrorValue]',
    () async {
      const response = Response(
        errors: [
          GraphQLError(
            message: 'message',
            extensions: {
              unauthenticatedErrorKey: 'differentError',
            },
          ),
        ],
      );

      expect(validator(response), false);
    },
  );
}
