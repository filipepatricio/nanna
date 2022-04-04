import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/progress_bar/audio_progress_bar_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioProgressBarCubit extends Cubit<AudioProgressBarState> {
  AudioProgressBarCubit(
    this._audioPositionStreamUseCase,
    this._audioPositionSeekUseCase,
  ) : super(AudioProgressBarState.inactive());

  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final AudioPositionSeekUseCase _audioPositionSeekUseCase;

  StreamSubscription? _audioProgressSubscription;

  @override
  Future<void> close() async {
    await _audioProgressSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _audioProgressSubscription = _audioPositionStreamUseCase().listen((event) {
      emit(
        AudioProgressBarState.active(
          event.position,
          event.totalDuration,
        ),
      );
    });
  }

  Future<void> seek(Duration position) async {
    await _audioPositionSeekUseCase(position);
  }
}
