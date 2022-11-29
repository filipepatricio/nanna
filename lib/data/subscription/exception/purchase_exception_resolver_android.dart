part of 'purchase_exception_resolver.di.dart';

@visibleForTesting
class PurchaseExceptionResolverAndroid extends PurchaseExceptionResolver {
  @override
  Object _parsePlatformException(PlatformException exception) {
    final details = exception.details;

    if (details is Map) {
      final json = details.cast<String, dynamic>();
      final message = json['underlyingErrorMessage'] as String?;

      if (message != null && message.contains('<html>')) return PurchaseServerException();
    }

    return exception;
  }
}
