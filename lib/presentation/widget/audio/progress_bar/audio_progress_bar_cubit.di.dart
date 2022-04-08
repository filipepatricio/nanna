import 'dart:async';

import 'package:better_informed_mobile/domain/audio/data/audio_position.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_state.dt.dart';
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

  Future<void> initialize([String? id]) async {
    _audioProgressSubscription = _audioPositionStreamUseCase().listen((event) {
      if (id == null) {
        _emitActive(event);
      } else {
        _resolveStateForSpecifiedID(id, event);
      }
    });
  }

  Future<void> seek(Duration position) async {
    await _audioPositionSeekUseCase(position);
  }

  void _resolveStateForSpecifiedID(String id, AudioPosition event) {
    if (id == event.audioItemID) {
      _emitActive(event);
    } else {
      emit(
        AudioProgressBarState.inactive(),
      );
    }
  }

  void _emitActive(AudioPosition event) {
    emit(
      AudioProgressBarState.active(
        event.position,
        event.totalDuration,
      ),
    );
  }
}
