import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/change_audio_speed_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/speed_button/audio_speed_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const _maxSpeed = 1.5;
const _defaultSpeed = 1.0;
const _speedStep = 0.25;

@injectable
class AudioSpeedButtonCubit extends Cubit<AudioSpeedButtonState> {
  AudioSpeedButtonCubit(
    this._changeAudioSpeedUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(AudioSpeedButtonState.disabled());

  final ChangeAudioSpeedUseCase _changeAudioSpeedUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  StreamSubscription? _playbackStateSubscription;

  @override
  Future<void> close() async {
    await _playbackStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _playbackStateSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      final newState = event.map(
        playing: (event) => AudioSpeedButtonState.enabled(event.speed),
        paused: (event) => AudioSpeedButtonState.enabled(event.speed),
        completed: (event) => AudioSpeedButtonState.enabled(event.speed),
        loading: (event) => AudioSpeedButtonState.enabled(event.speed),
        notInitialized: (_) => AudioSpeedButtonState.disabled(),
      );
      emit(newState);
    });
  }

  Future<void> switchSpeed() async {
    state.map(
      disabled: (_) {},
      enabled: (state) {
        final currentSpeed = state.speed;
        final potentialSpeed = currentSpeed + _speedStep;

        double newSpeed;
        if (potentialSpeed > _maxSpeed) {
          newSpeed = _defaultSpeed;
        } else {
          newSpeed = potentialSpeed;
        }

        _changeAudioSpeedUseCase(newSpeed);
      },
    );
  }
}
