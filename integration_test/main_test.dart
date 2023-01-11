import 'package:better_informed_mobile/main.dart' as app;
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'integration_test_ext.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('on app entry', () {
    testWidgets('open onboarding page', (tester) async {
      final FlutterExceptionHandler? originalOnError = FlutterError.onError;

      await app.main();
      await tester.pumpAndSettle();

      // reset onError after calling pumpAndSettle()
      FlutterError.onError = originalOnError;

      await tester.waitForView(find.byType(OnboardingPage));
      expect(find.byType(OnboardingPage), findsOneWidget);
    });
  });
}
