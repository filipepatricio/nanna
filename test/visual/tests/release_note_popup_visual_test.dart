import 'dart:async';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/empty_page.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/release_note_popup.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${ReleaseNotePopup}_(no_media)', (tester) async {
    await tester.startApp(initialRoute: const EmptyPageRoute());

    final context = tester.element(find.byType(EmptyPage).first);
    unawaited(ReleaseNotePopup.show(context, releaseNote: TestData.noMediaReleaseNote));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });

  visualTest('${ReleaseNotePopup}_(single_media)', (tester) async {
    await tester.startApp(initialRoute: const EmptyPageRoute());

    final context = tester.element(find.byType(EmptyPage).first);
    unawaited(ReleaseNotePopup.show(context, releaseNote: TestData.singleMediaReleaseNote));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });

  visualTest('${ReleaseNotePopup}_(multiple_media)', (tester) async {
    await tester.startApp(initialRoute: const EmptyPageRoute());

    final context = tester.element(find.byType(EmptyPage).first);
    unawaited(ReleaseNotePopup.show(context, releaseNote: TestData.multipleMediaReleaseNote));
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
