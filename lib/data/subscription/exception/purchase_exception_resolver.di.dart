import 'dart:async';

import 'package:better_informed_mobile/domain/subscription/exception/purchase_exception.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/object_wrappers.dart';

typedef PurchaseCall<T> = FutureOr<T> Function();

@injectable
class PurchaseExceptionResolver {
  const PurchaseExceptionResolver();

  FutureOr<T> callWithResolver<T>(PurchaseCall<T> call) async {
    try {
      return await call();
    } catch (exception) {
      if (exception is PlatformException) {
        throw _mapPlatformException(exception);
      }

      rethrow;
    }
  }

  PurchaseException _mapPlatformException(PlatformException exception) {
    final code = PurchasesErrorHelper.getErrorCode(exception);

    switch (code) {
      case PurchasesErrorCode.unknownError:
        return _tryToSolveUnknownException(exception);
      case PurchasesErrorCode.purchaseCancelledError:
        return PurchaseCancelledException(exception.message, exception.details);
      case PurchasesErrorCode.storeProblemError:
        return PurchaseStoreProblemException(exception.message, exception.details);
      case PurchasesErrorCode.purchaseNotAllowedError:
        return PurchaseNotAllowedException(exception.message, exception.details);
      case PurchasesErrorCode.purchaseInvalidError:
        return PurchaseInvalidException(exception.message, exception.details);
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        return PurchaseNotAvailableException(exception.message, exception.details);
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return PurchaseAlreadyOwnedException(exception.message, exception.details);
      case PurchasesErrorCode.receiptAlreadyInUseError:
        return PurchaseAlreadyInUseException(exception.message, exception.details);
      case PurchasesErrorCode.invalidReceiptError:
        return PurchaseInvalidReceiptException(exception.message, exception.details);
      case PurchasesErrorCode.missingReceiptFileError:
        return PurchaseMissingReceiptException(exception.message, exception.details);
      case PurchasesErrorCode.networkError:
        return PurchaseNetworkException(exception.message, exception.details);
      case PurchasesErrorCode.invalidCredentialsError:
        return PurchaseInvalidCredentialsException(exception.message, exception.details);
      case PurchasesErrorCode.unexpectedBackendResponseError:
        return PurchaseUnexpectedBackendResponseException(exception.message, exception.details);
      case PurchasesErrorCode.receiptInUseByOtherSubscriberError:
        return PurchaseReceiptInUseByOtherSubscriberException(exception.message, exception.details);
      case PurchasesErrorCode.invalidAppUserIdError:
        return PurchaseInvalidAppUserIdException(exception.message, exception.details);
      case PurchasesErrorCode.operationAlreadyInProgressError:
        return PurchaseOperationAlreadyInProgressException(exception.message, exception.details);
      case PurchasesErrorCode.unknownBackendError:
        return PurchaseUnknownBackendErrorException(exception.message, exception.details);
      case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
        return PurchaseInvalidAppleSubscriptionKeyException(exception.message, exception.details);
      case PurchasesErrorCode.ineligibleError:
        return PurchaseIneligibleException(exception.message, exception.details);
      case PurchasesErrorCode.insufficientPermissionsError:
        return PurchaseInsufficientPermissionsException(exception.message, exception.details);
      case PurchasesErrorCode.paymentPendingError:
        return PurchasePaymentPendingException(exception.message, exception.details);
      case PurchasesErrorCode.invalidSubscriberAttributesError:
        return PurchaseInvalidSubscriberAttributesException(exception.message, exception.details);
      case PurchasesErrorCode.logOutWithAnonymousUserError:
        return PurchaseLogOutWithAnonymousUserException(exception.message, exception.details);
      case PurchasesErrorCode.configurationError:
        return PurchaseConfigurationException(exception.message, exception.details);
      case PurchasesErrorCode.unsupportedError:
        return PurchaseUnsupportedException(exception.message, exception.details);
    }
  }

  PurchaseException _tryToSolveUnknownException(PlatformException exception) {
    if (exception.code == '35') {
      return PurchaseNetworkException(exception.message, exception.details);
    }

    return PurchaseUnknownException(exception.message, exception.details);
  }
}
