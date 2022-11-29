import 'package:better_informed_mobile/data/subscription/exception/purchase_exception_resolver.di.dart';
import 'package:better_informed_mobile/data/subscription/exception/purchase_server_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';

void main() {
  group('factory creates', () {
    test('iOS resolver', () {
      final factory = PurchaseExceptionResolverFactory(FakePlatform(operatingSystem: Platform.iOS));

      final resolver = factory.create();

      expect(resolver, isA<PurchaseExceptionResolverIOS>());
    });

    test('Android resolver', () {
      final factory = PurchaseExceptionResolverFactory(FakePlatform(operatingSystem: Platform.android));

      final resolver = factory.create();

      expect(resolver, isA<PurchaseExceptionResolverAndroid>());
    });
  });

  group('throws server exception', () {
    test('on iOS', () {
      final resolver = PurchaseExceptionResolverIOS();
      final originalException = PlatformException(
        code: '0',
        message: 'The operation couldn’t be completed. (RevenueCat.BackendError error 0.)',
      );

      expect(
        () => resolver.callWithResolver(() => throw originalException),
        throwsA(isA<PurchaseServerException>()),
      );
    });

    test('on Android', () {
      final resolver = PurchaseExceptionResolverAndroid();
      final originalException = PlatformException(
        code: '10',
        message: 'Error performing request.',
        details: {
          'code': '10',
          'message': 'Error performing request.',
          'readableErrorCode': 'NetworkError',
          'readable_error_code': 'NetworkError',
          'underlyingErrorMessage':
              'Value <html><head><title>503 of type java.lang.String cannot be converted to JSONObject',
        },
      );

      expect(
        () => resolver.callWithResolver(() => throw originalException),
        throwsA(isA<PurchaseServerException>()),
      );
    });
  });

  group('throws original exception', () {
    test('on iOS', () {
      final resolver = PurchaseExceptionResolverIOS();
      final originalException = PlatformException(
        code: '100',
        message: 'Some message',
        details: {
          'code': '100',
          'message': 'Some message',
        },
      );

      expect(
        () => resolver.callWithResolver(() => throw originalException),
        throwsA(originalException),
      );
    });

    test('on Android', () {
      final resolver = PurchaseExceptionResolverAndroid();
      final originalException = PlatformException(
        code: '100',
        message: 'Some message',
        details: {
          'code': '100',
          'message': 'Some message',
        },
      );

      expect(
        () => resolver.callWithResolver(() => throw originalException),
        throwsA(originalException),
      );
    });
  });
}
