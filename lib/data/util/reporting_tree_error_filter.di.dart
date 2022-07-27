import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

abstract class ReportingTreeErrorFilter {
  bool filterOut(dynamic error);
}

@injectable
class ReportingTreeErrorFilterController {
  final List<ReportingTreeErrorFilter> _filters = [
    _CubitClosedErrorFilter(),
    _FirebaseConnectionErrorFilter(),
    _ErrorFilter<NoInternetConnectionException>(),
    _ErrorFilter<UnauthorizedException>(),
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

class _FirebaseConnectionErrorFilter implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) {
    if (error is FirebaseException) {
      final message = error.message;
      if (message == null) return true;

      return message.contains('Could not connect to the server') ||
          message.contains('The Internet connection appears to be offline') ||
          message.contains('The network connection was lost') ||
          message.contains('International roaming is currently off') ||
          message.contains('The request timed out') ||
          message.contains('A data connection is not currently allowed') ||
          message.contains('TOO_MANY_REGISTRATIONS');
    }
    return false;
  }
}

class _ErrorFilter<T> implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) => error is T;
}
