import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:injectable/injectable.dart';

abstract class ReportingTreeErrorFilter {
  bool filterOut(dynamic error);
}

@injectable
class ReportingTreeErrorFilterController {
  final List<ReportingTreeErrorFilter> _filters = [
    _CubitClosedErrorFilter(),
    _TypeErrorFilter<NoInternetConnectionException>(),
    _TypeErrorFilter<UnauthorizedException>(),
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

class _TypeErrorFilter<T> implements ReportingTreeErrorFilter {
  @override
  bool filterOut(error) => error is T;
}
