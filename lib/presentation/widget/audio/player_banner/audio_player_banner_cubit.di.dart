import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/stop_audio_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AudioPlayerBannerCubit extends Cubit<AudioPlayerBannerState> {
  AudioPlayerBannerCubit(
    this._audioPlaybackStateStreamUseCase,
    this._stopAudioUseCase,
  ) : super(AudioPlayerBannerState.notInitialized());

  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final StopAudioUseCase _stopAudioUseCase;

  StreamSubscription? _audioStateSubscription;

  @override
  Future<void> close() async {
    await _audioStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _audioStateSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      event.map(
        notInitialized: (_) => emit(AudioPlayerBannerState.hidden()),
        loading: (_) => emit(AudioPlayerBannerState.hidden()),
        playing: (state) => emit(AudioPlayerBannerState.visible(state.audioItem)),
        paused: (state) => emit(AudioPlayerBannerState.visible(state.audioItem)),
        completed: (state) => emit(AudioPlayerBannerState.visible(state.audioItem)),
      );
    });
  }

  Future<void> stop() async {
    await _stopAudioUseCase();
  }
}
