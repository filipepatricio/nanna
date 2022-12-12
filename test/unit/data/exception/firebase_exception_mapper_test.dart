import 'package:better_informed_mobile/data/exception/firebase/firebase_authentication_exception.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_network_exception.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_unknown_exception.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FirebaseExceptionMapper firebaseExceptionMapper;

  setUp(() {
    firebaseExceptionMapper = FirebaseExceptionMapper();
  });

  group('mapAndThrow', () {
    test('throws FirebaseAuthenticationException', () {
      final exception = FirebaseException(
        plugin: 'plugin',
        message: 'AUTHENTICATION_FAILED',
      );

      expect(
        () => firebaseExceptionMapper.mapAndThrow(exception),
        throwsA(isA<FirebaseAuthenticationException>()),
      );
    });

    test('throws FirebaseNetworkException', () {
      final exception = FirebaseException(
        plugin: 'plugin',
        message: 'Could not connect to the server',
      );

      expect(
        () => firebaseExceptionMapper.mapAndThrow(exception),
        throwsA(isA<FirebaseNetworkException>()),
      );
    });

    test('throws FirebaseUnknownException', () {
      final exception = FirebaseException(
        plugin: 'plugin',
        message: 'some exception that might actually be important',
        code: 'some code',
      );

      expect(
        () => firebaseExceptionMapper.mapAndThrow(exception),
        throwsA(isA<FirebaseUnknownException>()),
      );
    });
  });
}
