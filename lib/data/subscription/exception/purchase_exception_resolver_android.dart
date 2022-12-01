part of 'purchase_exception_resolver.di.dart';

@visibleForTesting
class PurchaseExceptionResolverAndroid extends PurchaseExceptionResolver {
  @override
  Object _parsePlatformException(PlatformException exception) {
    final message = exception.message;

    if (message != null) {
      if (message.contains('There is no singleton instance')) {
        Fimber.e('Purchases not configured', ex: PurchasesNotConfiguredException());
        return PurchasesNotConfiguredException();
      }
    }

    final details = exception.details;

    if (details is Map) {
      final json = details.cast<String, dynamic>();
      final message = json['underlyingErrorMessage'] as String?;
      final code = json['readableErrorCode'] as String?;

      if (message != null && message.contains('<html>')) return PurchaseServerException();
      if (code != null && code == 'NetworkError') return NoInternetConnectionException();
    }

    return exception;
  }
}
