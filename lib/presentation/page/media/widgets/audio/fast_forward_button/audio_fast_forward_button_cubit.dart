import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/fast_forward_audio_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/fast_forward_button/audio_fast_forward_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AufioFastForwardButtonCubit extends Cubit<AudioFastForwardButtonState> {
  AufioFastForwardButtonCubit(
    this._fastForwardAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(AudioFastForwardButtonState.disabled());

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
        playing: (_) => AudioFastForwardButtonState.enabled(),
        paused: (_) => AudioFastForwardButtonState.enabled(),
        orElse: () => AudioFastForwardButtonState.disabled(),
      );
      emit(newState);
    });
  }

  Future<void> fastForward() async {
    await _fastForwardAudioUseCase();
  }
}
