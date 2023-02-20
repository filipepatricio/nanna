import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/play_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/audio/audio_page.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../finders.dart';
import '../../../../../test_data.dart';
import '../../../../unit_test_utils.dart';

void main() {
  testWidgets('pressing on banner opens audio page', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AudioPlaybackStateStreamUseCase>(() => FakeAudioPlaybackStateStreamUseCase());
      },
      initialRoute: const MainPageRoute(),
    );

    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(AudioPlayerBanner));
    _expectExpandedBanner(tester);
    await tester.tap(find.byType(AudioPlayerBanner));

    while (find.byType(AudioPage).evaluate().isEmpty) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    await tester.pump(const Duration(milliseconds: 400));

    await tester.ensureVisible(find.byType(AudioPage));
  });

  testWidgets('pressing on control button changes audio state', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        await getIt<PrepareArticleAudioTrackUseCase>().call(article: TestData.premiumArticleWithAudio);
        await getIt<PlayAudioUseCase>().call();
      },
      initialRoute: const MainPageRoute(),
    );

    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(AudioPlayerBanner));
    _expectExpandedBanner(tester);

    final pauseButton = find.descendant(
      of: find.byType(AudioPlayerBanner),
      matching: find.byType(AudioControlButton),
    );
    expect(pauseButton, findsOneWidget);
    expect(
      find.descendant(
        of: pauseButton,
        matching: find.bySvgAssetName(AppVectorGraphics.pause),
      ),
      findsOneWidget,
    );
    await tester.tap(pauseButton);

    await tester.pumpAndSettle();

    final playButton = find.descendant(
      of: find.byType(AudioPlayerBanner),
      matching: find.byType(AudioControlButton),
    );
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

    expect(
      find.descendant(
        of: pauseButton,
        matching: find.bySvgAssetName(AppVectorGraphics.pause),
      ),
      findsOneWidget,
    );
  });

  testWidgets('pressing on close button hides banner', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        await getIt<PrepareArticleAudioTrackUseCase>().call(article: TestData.premiumArticleWithAudio);
        await getIt<PlayAudioUseCase>().call();
      },
      initialRoute: const MainPageRoute(),
    );

    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(AudioPlayerBanner));
    _expectExpandedBanner(tester);

    final closeButton = find.descendant(
      of: find.byType(AudioPlayerBanner),
      matching: find.bySvgAssetName(AppVectorGraphics.close),
    );
    expect(closeButton, findsOneWidget);
    await tester.tap(closeButton);

    await tester.pumpAndSettle();

    expect(find.byType(AudioPlayerBanner), findsOneWidget);
    _expectCollapsedBanner(tester);
  });
}

void _expectExpandedBanner(WidgetTester tester) {
  expect((find.byType(AudioPlayerBanner).evaluate().first.size?.height ?? 0) > 0, true);
}

void _expectCollapsedBanner(WidgetTester tester) {
  expect(find.byType(AudioPlayerBanner).evaluate().first.size?.height, 0);
}

class FakeAudioPlaybackStateStreamUseCase extends Fake implements AudioPlaybackStateStreamUseCase {
  @override
  Stream<AudioPlaybackState> call() => Stream.value(
        AudioPlaybackState.playing(
          speed: 1.0,
          audioItem: AudioItem(
            author: '',
            duration: const Duration(minutes: 1),
            id: '000',
            imageUrl: null,
            slug: TestData.premiumArticleWithAudio.slug,
            title: 'Test audio',
          ),
        ),
      );
}
