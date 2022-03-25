import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/pause_audio_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/play_audio_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_control_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioControlButtonCubit extends Cubit<AudioControlButtonState> {
  AudioControlButtonCubit(
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(AudioControlButtonState.initializing());

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
      final state = event.playing ? AudioControlButtonState.playing() : AudioControlButtonState.paused();
      emit(state);
    });
  }

  Future<void> play() async {
    await _playAudioUseCase();
  }

  Future<void> pause() async {
    await _pauseAudioUseCase();
  }
}
