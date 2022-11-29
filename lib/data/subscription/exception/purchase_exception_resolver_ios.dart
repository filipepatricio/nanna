part of 'purchase_exception_resolver.di.dart';

@visibleForTesting
class PurchaseExceptionResolverIOS extends PurchaseExceptionResolver {
  @override
  Object _parsePlatformException(PlatformException exception) {
    final message = exception.message;

    if (message != null && message.contains('RevenueCat.BackendError')) {
      return PurchaseServerException();
    }

    return exception;
  }
}
