import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/rewind_audio_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/rewind_button/audio_rewind_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioRewindButtonCubit extends Cubit<AudioRewindButtonState> {
  AudioRewindButtonCubit(
    this._rewindAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(AudioRewindButtonState.disabled());

  final RewindAudioUseCase _rewindAudioUseCase;
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
        playing: (_) => AudioRewindButtonState.enabled(),
        paused: (_) => AudioRewindButtonState.enabled(),
        orElse: () => AudioRewindButtonState.disabled(),
      );
      emit(newState);
    });
  }

  Future<void> rewind() async {
    await _rewindAudioUseCase();
  }
}
