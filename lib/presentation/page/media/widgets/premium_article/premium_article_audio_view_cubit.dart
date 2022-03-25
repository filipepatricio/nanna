import 'dart:async';

import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/pause_audio_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/play_audio_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.dart';
import 'package:better_informed_mobile/domain/audio/use_case/stop_audio_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PremiumArticleAudioViewCubit extends Cubit<PremiumArticleAudioViewState> {
  PremiumArticleAudioViewCubit(
    this._prepareAudioTrackUseCase,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._stopAudioUseCase,
  ) : super(PremiumArticleAudioViewState.initializing());

  final PrepareAudioTrackUseCase _prepareAudioTrackUseCase;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  StreamSubscription? _playbackStateSubscription;

  @override
  Future<void> close() async {
    await _playbackStateSubscription?.cancel();
    await _stopAudioUseCase();
    return super.close();
  }

  Future<void> initialize(MediaItemArticle article, String? imageUrl) async {
    await _prepareAudioTrackUseCase(article, imageUrl);

    _playbackStateSubscription = _audioPlaybackStateStreamUseCase().listen(
      (playbackState) {
        final newState = playbackState.playing
            ? PremiumArticleAudioViewState.playing(playbackState.duration)
            : PremiumArticleAudioViewState.paused(playbackState.duration);
        emit(newState);
      },
    );
  }

  Future<void> play() async {
    await _playAudioUseCase();
  }

  Future<void> pause() async {
    await _pauseAudioUseCase();
  }
}
