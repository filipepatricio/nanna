import 'package:fimber/fimber.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryReportingTree implements LogTree {
  @override
  Future<void> log(
    String level,
    String message, {
    String? tag,
    dynamic ex,
    StackTrace? stacktrace,
  }) async {
    if (ex != null) {
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
