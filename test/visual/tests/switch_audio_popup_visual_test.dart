import 'dart:async';

import 'package:better_informed_mobile/presentation/widget/audio/switch_audio/switch_audio_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SwitchAudioPopup, (tester) async {
    await tester.startApp();

    final context = tester.element(find.byType(Container).first);
    unawaited(showSwitchAudioPopup(context));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
