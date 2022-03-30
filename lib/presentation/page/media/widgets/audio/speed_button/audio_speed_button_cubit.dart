import 'dart:async';

import 'package:better_informed_mobile/presentation/page/media/widgets/audio/speed_button/audio_speed_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioSpeedButtonCubit extends Cubit<AudioSpeedButtonState> {
  AudioSpeedButtonCubit() : super(AudioSpeedButtonState.notInitialized());

  StreamSubscription? _playbackStateSubscription;

  @override
  Future<void> close() async {
    await _playbackStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {}

  Future<void> switchSpeed() async {}
}
