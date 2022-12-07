abstract class PurchaseException implements Exception {
  const PurchaseException(this.message, this.details);

  final String? message;
  final dynamic details;

  @override
  String toString() {
    return '$runtimeType{message: $message, details: $details}';
  }
}

class PurchaseUnknownException extends PurchaseException {
  PurchaseUnknownException(super.message, super.details);
}

class PurchaseCancelledException extends PurchaseException {
  PurchaseCancelledException(super.message, super.details);
}

class PurchaseStoreProblemException extends PurchaseException {
  PurchaseStoreProblemException(super.message, super.details);
}

class PurchaseNotAllowedException extends PurchaseException {
  PurchaseNotAllowedException(super.message, super.details);
}

class PurchaseInvalidException extends PurchaseException {
  PurchaseInvalidException(super.message, super.details);
}

class PurchaseNotAvailableException extends PurchaseException {
  PurchaseNotAvailableException(super.message, super.details);
}

class PurchaseAlreadyOwnedException extends PurchaseException {
  PurchaseAlreadyOwnedException(super.message, super.details);
}

class PurchaseAlreadyInUseException extends PurchaseException {
  PurchaseAlreadyInUseException(super.message, super.details);
}

class PurchaseInvalidReceiptException extends PurchaseException {
  PurchaseInvalidReceiptException(super.message, super.details);
}

class PurchaseMissingReceiptException extends PurchaseException {
  PurchaseMissingReceiptException(super.message, super.details);
}

class PurchaseNetworkException extends PurchaseException {
  PurchaseNetworkException(super.message, super.details);
}

class PurchaseInvalidCredentialsException extends PurchaseException {
  PurchaseInvalidCredentialsException(super.message, super.details);
}

class PurchaseUnexpectedBackendResponseException extends PurchaseException {
  PurchaseUnexpectedBackendResponseException(super.message, super.details);
}

class PurchaseReceiptInUseByOtherSubscriberException extends PurchaseException {
  PurchaseReceiptInUseByOtherSubscriberException(super.message, super.details);
}

class PurchaseInvalidAppUserIdException extends PurchaseException {
  PurchaseInvalidAppUserIdException(super.message, super.details);
}

class PurchaseOperationAlreadyInProgressException extends PurchaseException {
  PurchaseOperationAlreadyInProgressException(super.message, super.details);
}

class PurchaseUnknownBackendErrorException extends PurchaseException {
  PurchaseUnknownBackendErrorException(super.message, super.details);
}

class PurchaseInvalidAppleSubscriptionKeyException extends PurchaseException {
  PurchaseInvalidAppleSubscriptionKeyException(super.message, super.details);
}

class PurchaseIneligibleException extends PurchaseException {
  PurchaseIneligibleException(super.message, super.details);
}

class PurchaseInsufficientPermissionsException extends PurchaseException {
  PurchaseInsufficientPermissionsException(super.message, super.details);
}

class PurchasePaymentPendingException extends PurchaseException {
  PurchasePaymentPendingException(super.message, super.details);
}

class PurchaseInvalidSubscriberAttributesException extends PurchaseException {
  PurchaseInvalidSubscriberAttributesException(super.message, super.details);
}

class PurchaseLogOutWithAnonymousUserException extends PurchaseException {
  PurchaseLogOutWithAnonymousUserException(super.message, super.details);
}

class PurchaseConfigurationException extends PurchaseException {
  PurchaseConfigurationException(super.message, super.details);
}

class PurchaseUnsupportedException extends PurchaseException {
  PurchaseUnsupportedException(super.message, super.details);
}
