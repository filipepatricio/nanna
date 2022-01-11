import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_test_utils.dart';

void main() {
  visualTest(OnboardingPage, (tester, device) async {
    await tester.startApp(initialRoute: const OnboardingPageRoute());
    await matchGoldenFile('onboarding_page_1');
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await matchGoldenFile('onboarding_page_2');
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await matchGoldenFile('onboarding_page_3');
  });
}
