import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/pause_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/play_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_control_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioControlButtonCubit extends Cubit<AudioControlButtonState> {
  AudioControlButtonCubit(
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._prepareAudioTrackUseCase,
  ) : super(AudioControlButtonState.loading());

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  StreamSubscription? _audioPlaybackSubscription;

  @override
  Future<void> close() async {
    await _audioPlaybackSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _audioPlaybackSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      final state = event.map(
        notInitialized: (_) => AudioControlButtonState.notInitilized(),
        loading: (_) => AudioControlButtonState.loading(),
        playing: (_) => AudioControlButtonState.playing(),
        paused: (_) => AudioControlButtonState.paused(),
        completed: (_) => AudioControlButtonState.paused(),
      );
      emit(state);
    });
  }

  Future<void> play(MediaItemArticle article, String? imageUrl) async {
    await state.mapOrNull(
      notInitilized: (_) async {
        await _prepareAudioTrackUseCase(
          article: article,
          imageUrl: imageUrl,
        );
        await _playAudioUseCase();
      },
      paused: (_) => _playAudioUseCase(),
    );
  }

  Future<void> pause() async {
    await _pauseAudioUseCase();
  }
}
