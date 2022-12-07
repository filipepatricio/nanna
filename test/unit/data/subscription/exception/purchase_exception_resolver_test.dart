import 'package:better_informed_mobile/data/subscription/exception/purchase_exception_resolver.di.dart';
import 'package:better_informed_mobile/domain/subscription/exception/purchase_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PurchaseExceptionResolver resolver;

  setUp(() {
    resolver = const PurchaseExceptionResolver();
  });

  test('callWithResolver should return the result of the function', () async {
    final result = await resolver.callWithResolver(() => Future.value(1));

    expect(result, 1);
  });

  group('callWithResolver should throw', () {
    test('the exception if the function throws', () async {
      final exception = Exception();

      expect(
        () => resolver.callWithResolver(() => Future.error(exception)),
        throwsA(exception),
      );
    });

    test('the PurchaseUnknownException if the function throws PlatformException with code 0', () async {
      final exception = PlatformException(code: '0');

      expect(
        () => resolver.callWithResolver(() => Future.error(exception)),
        throwsA(
          isA<PurchaseUnknownException>(),
        ),
      );
    });

    test('the PurchaseNetworkException if the function throws PlatformException with code 35', () async {
      final exception = PlatformException(code: '35');

      expect(
        () => resolver.callWithResolver(() => Future.error(exception)),
        throwsA(
          isA<PurchaseNetworkException>(),
        ),
      );
    });
  });
}
