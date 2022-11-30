part of 'purchase_exception_resolver.di.dart';

@injectable
class PurchaseExceptionResolverFactory {
  PurchaseExceptionResolverFactory(this._platform);

  final Platform _platform;

  PurchaseExceptionResolver create() {
    if (_platform.isIOS) {
      return PurchaseExceptionResolverIOS();
    } else {
      return PurchaseExceptionResolverAndroid();
    }
  }
}
