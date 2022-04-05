import 'package:better_informed_mobile/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upgrader/upgrader.dart';
import '../more_finders.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'app udpate dialog does not show up under normal circumstances',
    (tester) async {
      await tester.startApp();
      expect(find.byText(LocaleKeys.update_title.tr()), findsNothing);
    },
  );

  testWidgets(
    'dialog shows up when app is outdated',
    (tester) async {
      // Forcing dialog to show because fetching and solving version logic is already tested by package
      Upgrader().debugDisplayAlways = true;
      await tester.startApp();
      expect(find.byText(LocaleKeys.update_title.tr()), findsOneWidget);
    },
  );

  tearDown(() {
    Upgrader().debugDisplayAlways = false;
  });
}
