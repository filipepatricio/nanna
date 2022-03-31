import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/fast_forward_audio_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/rewind_audio_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/seek_button/audio_seek_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioSeekButtonCubit extends Cubit<AudioSeekButtonState> {
  AudioSeekButtonCubit(
    this._rewindAudioUseCase,
    this._fastForwardAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(AudioSeekButtonState.disabled());

  final RewindAudioUseCase _rewindAudioUseCase;
  final FastForwardAudioUseCase _fastForwardAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  StreamSubscription? _playbackStateSubscription;

  @override
  Future<void> close() async {
    await _playbackStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _playbackStateSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      final newState = event.maybeMap(
        playing: (_) => AudioSeekButtonState.enabled(),
        paused: (_) => AudioSeekButtonState.enabled(),
        orElse: () => AudioSeekButtonState.disabled(),
      );
      emit(newState);
    });
  }

  Future<void> rewind() async {
    await _rewindAudioUseCase();
  }

  Future<void> fastForward() async {
    await _fastForwardAudioUseCase();
  }
}
