part of 'purchase_exception_resolver.di.dart';

@visibleForTesting
class PurchaseExceptionResolverIOS extends PurchaseExceptionResolver {
  @override
  Object _parsePlatformException(PlatformException exception) {
    final message = exception.message;
    final details = exception.details;

    if (message != null) {
      if (message.contains('RevenueCat.BackendError')) {
        return PurchaseServerException();
      }

      if (message.contains('There is no singleton instance')) {
        Fimber.e('Purchases not configured', ex: PurchasesNotConfiguredException());
        return PurchasesNotConfiguredException();
      }
    }

    if (details is Map) {
      final json = details.cast<String, dynamic>();
      final code = json['readableErrorCode'] as String?;

      if (code != null && code == 'OFFLINE_CONNECTION_ERROR') return NoInternetConnectionException();
    }

    return exception;
  }
}
