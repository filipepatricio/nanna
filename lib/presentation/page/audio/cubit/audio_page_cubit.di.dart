import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/audio/cubit/audio_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioPageCubit extends Cubit<AudioPageState> {
  AudioPageCubit(
    this._prepareAudioTrackUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(AudioPageState.initializing());

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  late MediaItemArticle _article;
  late String? _imageUrl;

  StreamSubscription? _playbackStateSubscription;

  @override
  Future<void> close() async {
    await _playbackStateSubscription?.cancel();

    return super.close();
  }

  Future<void> initialize(MediaItemArticle article, String? imageUrl) async {
    _article = article;
    _imageUrl = imageUrl;

    _playbackStateSubscription = _audioPlaybackStateStreamUseCase().listen(
      (playbackState) {
        final newState = playbackState.maybeMap(
          notInitialized: (_) {
            _prepareAudioTrackUseCase(
              article: _article,
              imageUrl: _imageUrl,
            );
            return AudioPageState.notInitialized();
          },
          loading: (_) => AudioPageState.initializing(),
          orElse: () => AudioPageState.initialized(),
        );
        emit(newState);
      },
    );
  }
}
