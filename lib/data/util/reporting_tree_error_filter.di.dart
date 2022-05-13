import 'package:injectable/injectable.dart';

abstract class ReportingTreeErrorFilter {
  bool filterOut(dynamic error);
}

@injectable
class ReportingTreeErrorFilterController {
  final List<ReportingTreeErrorFilter> _filters = [
    _CubitClosedErrorFilter(),
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
