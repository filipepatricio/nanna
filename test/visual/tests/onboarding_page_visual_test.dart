import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(OnboardingPage, (tester) async {
    await tester.startApp(initialRoute: const OnboardingPageRoute());
    await tester.matchGoldenFile('onboarding_page_(step_1)');
    await tester.fling(find.byType(PageView).first, const Offset(-1000, 0), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('onboarding_page_(step_2)');
    await tester.fling(find.byType(PageView).first, const Offset(-1000, 0), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('onboarding_page_(step_3)');
    await tester.fling(find.byType(PageView).first, const Offset(-1000, 0), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('onboarding_page_(step_4)');
  });
}
