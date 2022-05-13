import 'package:better_informed_mobile/data/util/reporting_tree_error_filter.di.dart';
import 'package:fimber/fimber.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryReportingTree implements LogTree {
  SentryReportingTree(this._filterController);

  final ReportingTreeErrorFilterController _filterController;

  @override
  Future<void> log(
    String level,
    String message, {
    String? tag,
    dynamic ex,
    StackTrace? stacktrace,
  }) async {
    if (ex != null) {
      if (_filterController.shouldFilterOut(ex)) return;

      await Sentry.captureException(
        ex,
        stackTrace: stacktrace,
        hint: message,
      );
    }
  }

  @override
  List<String> getLevels() => ['W', 'E'];
}
