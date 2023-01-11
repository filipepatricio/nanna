import 'package:flutter_test/flutter_test.dart';

extension IntegrationTestExt on WidgetTester {
  Future<void> waitForView(
    Finder view, [
    Duration timeout = const Duration(seconds: 10),
  ]) async {
    int timePassed = 0;
    bool noTimedOut = true;

    while (noTimedOut) {
      if (view.evaluate().isNotEmpty) return;
      await pump(const Duration(milliseconds: 16));

      timePassed += 16;
      if (timePassed >= timeout.inMilliseconds) noTimedOut = false;
    }

    throw Exception(view.toString());
  }
}
