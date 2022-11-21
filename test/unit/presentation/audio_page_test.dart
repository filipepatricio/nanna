import 'package:better_informed_mobile/presentation/page/audio/audio_page.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_close_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../finders.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'pressing play button changes the state',
    (tester) async {
      await tester.startApp(
        initialRoute: AudioPageRoute(
          article: TestData.premiumArticleWithAudio,
          audioFile: TestData.audioFile,
        ),
      );

      final playButton = find.byType(AudioControlButton);
      expect(playButton, findsOneWidget);
      expect(
        find.descendant(
          of: playButton,
          matching: find.bySvgAssetName(AppVectorGraphics.playArrow),
        ),
        findsOneWidget,
      );

      await tester.tap(playButton);
      await tester.pumpAndSettle();

      final pauseButton = find.byType(AudioControlButton);
      expect(pauseButton, findsOneWidget);
      expect(
        find.descendant(
          of: pauseButton,
          matching: find.bySvgAssetName(AppVectorGraphics.pause),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'pressing close button hides audio page',
    (tester) async {
      await tester.startApp(
        initialRoute: AudioPageRoute(
          article: TestData.premiumArticleWithAudio,
          audioFile: TestData.audioFile,
        ),
      );

      final closeButton = find.descendant(
        of: find.byType(AudioPage),
        matching: find.byType(InformedCloseButton),
      );
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);

      await tester.pumpAndSettle();

      expect(find.byType(AudioPage), findsNothing);
    },
  );

  testWidgets(
    'swiping down closes audio page',
    (tester) async {
      await tester.startApp(
        initialRoute: AudioPageRoute(
          article: TestData.premiumArticleWithAudio,
          audioFile: TestData.audioFile,
        ),
      );

      await tester.fling(find.byType(AudioPage), const Offset(0, 1000), 100);

      await tester.pumpAndSettle();

      expect(find.byType(AudioPage), findsNothing);
    },
  );
}
