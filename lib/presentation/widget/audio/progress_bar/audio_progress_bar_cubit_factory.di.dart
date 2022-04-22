import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioProgressBarCubitFactory extends CubitFactory<AudioProgressBarCubit> {
  AudioProgressBarCubitFactory(
    this._audioPositionStreamUseCase,
    this._audioPositionSeekUseCase,
  );

  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final AudioPositionSeekUseCase _audioPositionSeekUseCase;

  static AudioProgressBarCubit? _currentAudioInstance;

  String? _audioId;

  void setAudioId(String id) {
    _audioId = id;
  }

  @override
  AudioProgressBarCubit create() {
    if (_audioId == null) {
      _currentAudioInstance ??= AudioProgressBarCubit.currentAudio(
        _audioPositionStreamUseCase,
        _audioPositionSeekUseCase,
      );
      return _currentAudioInstance!;
    }

    return AudioProgressBarCubit(
      _audioPositionStreamUseCase,
      _audioPositionSeekUseCase,
      _audioId,
    );
  }
}
