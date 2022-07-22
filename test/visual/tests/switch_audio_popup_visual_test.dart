import 'dart:async';

import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/switch_audio/switch_audio_popup.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SwitchAudioPopup, (tester) async {
    await tester.startApp();

    final context = tester.element(find.byType(DailyBriefPage).first);
    unawaited(showSwitchAudioPopup(context));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
