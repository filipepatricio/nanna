import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PremiumArticleAudioCubit extends Cubit<PremiumArticleAudioState> {
  PremiumArticleAudioCubit(
    this._prepareAudioTrackUseCase,
    this._audioPlaybackStateStreamUseCase,
  ) : super(PremiumArticleAudioState.initializing());

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
          notInitialized: (_) => PremiumArticleAudioState.notInitialized(),
          loading: (_) => PremiumArticleAudioState.initializing(),
          orElse: () => PremiumArticleAudioState.initialized(),
        );
        emit(newState);
      },
    );
  }

  Future<void> preload() async {
    await state.maybeMap(
      notInitialized: (_) async {
        await _prepareAudioTrackUseCase(
          article: _article,
          imageUrl: _imageUrl,
        );
      },
      orElse: () async {},
    );
  }
}
