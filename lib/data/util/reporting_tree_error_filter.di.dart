import 'dart:io';

import 'package:better_informed_mobile/data/exception/firebase/firebase_authentication_exception.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_network_exception.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/exception/server_error_exception.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:better_informed_mobile/domain/subscription/exception/purchase_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class ReportingTreeErrorFilter {
  bool filterOut(dynamic error);
}

@injectable
class ReportingTreeErrorFilterController {
  final List<ReportingTreeErrorFilter> _filters = [
    _CubitClosedErrorFilter(),
    _FirebaseExceptionFilter(),
    _SignInWithAppleAuthorizationErrorFilter(),
    _HttpExceptionErrorFilter(),
    _ErrorFilter<NoInternetConnectionException>(),
    _ErrorFilter<UnauthorizedException>(),
    _ErrorFilter<ServerErrorException>(),
    _ErrorFilter<PurchaseNetworkException>(),
    _ErrorFilter<PurchaseNotAllowedException>(),
    _ErrorFilter<PurchaseStoreProblemException>(),
    _ErrorFilter<PurchaseUnexpectedBackendResponseException>(),
    _ErrorFilter<PurchaseUnknownBackendErrorException>(),
    _ErrorFilter<SocketException>(),
  ];

  bool shouldFilterOut(dynamic error) {
    return _filters.any((element) => element.filterOut(error));
  }
}

class _CubitClosedErrorFilter implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) {
    return error is StateError && error.message == 'Cannot emit new states after calling close';
  }
}

class _SignInWithAppleAuthorizationErrorFilter implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) {
    if (error is SignInWithAppleAuthorizationException) {
      final message = error.message;

      return message.contains('com.apple.AuthenticationServices.AuthorizationError error 1000');
    }
    return false;
  }
}

class _FirebaseExceptionFilter implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) {
    return error is FirebaseNetworkException || error is FirebaseAuthenticationException;
  }
}

class _HttpExceptionErrorFilter implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) {
    if (error is HttpException) {
      final message = error.toString();

      return message.contains('Connection closed while receiving data') &&
          message.contains('informed-audio-production');
    }
    return false;
  }
}

class _ErrorFilter<T> implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) => error is T;
}
