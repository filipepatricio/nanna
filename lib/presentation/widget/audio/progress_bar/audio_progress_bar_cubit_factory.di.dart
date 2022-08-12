import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioProgressBarCubitFactory extends CubitFactory<AudioProgressBarCubit> {
  AudioProgressBarCubitFactory(
    this._audioPositionStreamUseCase,
    this._audioPositionSeekUseCase,
    this._articleAudioProgressUseCase,
    this._audioPlaybackStateStreamUseCase,
  );

  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final AudioPositionSeekUseCase _audioPositionSeekUseCase;
  final GetArticleAudioProgressUseCase _articleAudioProgressUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  static AudioProgressBarCubit? _currentAudioInstance;

  MediaItemArticle? _article;

  void setArticle(MediaItemArticle article) {
    _article = article;
  }

  @override
  AudioProgressBarCubit create() {
    if (_article == null) {
      _currentAudioInstance ??= AudioProgressBarCubit.currentAudio(
        _audioPositionStreamUseCase,
        _audioPositionSeekUseCase,
        _articleAudioProgressUseCase,
        _audioPlaybackStateStreamUseCase,
      );
      return _currentAudioInstance!;
    }

    return AudioProgressBarCubit(
      _audioPositionStreamUseCase,
      _audioPositionSeekUseCase,
      _articleAudioProgressUseCase,
      _audioPlaybackStateStreamUseCase,
      _article,
    );
  }
}
