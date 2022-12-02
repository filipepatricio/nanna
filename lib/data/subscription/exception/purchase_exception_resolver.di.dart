import 'dart:async';

import 'package:better_informed_mobile/data/subscription/exception/purchase_server_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:platform/platform.dart';

part 'purchase_exception_resolver_android.dart';
part 'purchase_exception_resolver_factory.dart';
part 'purchase_exception_resolver_ios.dart';

typedef PurchaseCall<T> = FutureOr<T> Function();

abstract class PurchaseExceptionResolver {
  const PurchaseExceptionResolver();

  FutureOr<T> callWithResolver<T>(PurchaseCall<T> call) async {
    try {
      return await call();
    } catch (exception) {
      if (exception is PlatformException) {
        throw _parsePlatformException(exception);
      }

      rethrow;
    }
  }

  Object _parsePlatformException(PlatformException exception);
}
