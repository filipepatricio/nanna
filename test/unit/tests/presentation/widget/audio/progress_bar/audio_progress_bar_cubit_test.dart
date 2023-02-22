import 'dart:async';

import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../generated_mocks.mocks.dart';
import '../../../../../../test_data.dart';

const double _progress = 5.0;

void main() {
  late AudioProgressBarCubit audioProgressBarCubit;

  late AudioPositionStreamUseCase audioPositionStreamUseCase;
  late AudioPositionSeekUseCase audioPositionSeekUseCase;
  late GetArticleAudioProgressUseCase articleAudioProgressUseCase;
  late AudioPlaybackStateStreamUseCase audioPlaybackStateStreamUseCase;

  late MediaItemArticle article;

  setUp(() {
    article = TestData.premiumArticleWithAudio;

    audioPositionStreamUseCase = MockAudioPositionStreamUseCase();
    audioPositionSeekUseCase = MockAudioPositionSeekUseCase();
    articleAudioProgressUseCase = MockGetArticleAudioProgressUseCase();
    audioPlaybackStateStreamUseCase = MockAudioPlaybackStateStreamUseCase();

    audioProgressBarCubit = AudioProgressBarCubit(
      audioPositionStreamUseCase,
      audioPositionSeekUseCase,
      articleAudioProgressUseCase,
      audioPlaybackStateStreamUseCase,
      article,
    );

    when(audioPlaybackStateStreamUseCase()).thenAnswer(
      (_) => Stream.value(
        AudioPlaybackState.loading(
          audioItem: TestData.audioItem,
          speed: 1,
        ),
      ),
    );

    when(audioPositionStreamUseCase()).thenAnswer((_) => Stream.value(TestData.audioPosition));
  });

  test('emit [AudioProgressBarState.initial] when progress bar is loading', () {
    expect(audioProgressBarCubit.state, AudioProgressBarState.initial());
  });

  test('emit [AudioProgressBarState.active] when playback state is active', () {
    audioProgressBarCubit.initialize();

    expect(
      audioProgressBarCubit.stream,
      emitsInOrder([
        AudioProgressBarState.initial(),
        AudioProgressBarState.active(
          TestData.audioPosition.position,
          TestData.audioPosition.totalDuration,
        )
      ]),
    );
  });

  test('emit [AudioProgressBarState.inactive] when is other audio', () {
    when(audioPositionStreamUseCase()).thenAnswer(
      (_) => Stream.value(
        TestData.audioPosition.copyWith(audioItemID: 'other-id'),
      ),
    );

    when(articleAudioProgressUseCase(article)).thenAnswer((_) => _progress);

    audioProgressBarCubit.initialize();

    expectLater(
      audioProgressBarCubit.stream,
      emitsInOrder(
        [
          AudioProgressBarState.initial(),
          AudioProgressBarState.inactive(_progress),
        ],
      ),
    );
  });
}
