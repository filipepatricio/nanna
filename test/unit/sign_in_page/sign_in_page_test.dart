import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../more_finders.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'sign in with apple button shows on apple device',
    (tester) async {
      kIsAppleDevice = true;
      await tester.startApp(initialRoute: const SignInPageRoute());
      await tester.pumpAndSettle();
      expect(find.byText(LocaleKeys.signIn_providerButton_apple.tr()), findsOneWidget);
    },
  );

  testWidgets(
    'sign in with google button shows on android device',
    (tester) async {
      kIsAppleDevice = false;
      await tester.startApp(initialRoute: const SignInPageRoute());
      await tester.pumpAndSettle();
      expect(find.byText(LocaleKeys.signIn_providerButton_google.tr()), findsOneWidget);
    },
  );

  testWidgets(
    'magic link sent page is shown after submitting an email address',
    (tester) async {
      await tester.startApp(initialRoute: const SignInPageRoute());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is EmailInput && !widget.validEmail), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'mail@domain.com');
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is EmailInput && widget.validEmail), findsOneWidget);
    },
  );
}
