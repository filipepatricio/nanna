import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/stop_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PremiumArticleAudioCubit extends Cubit<PremiumArticleAudioState> {
  PremiumArticleAudioCubit(
    this._prepareAudioTrackUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._stopAudioUseCase,
    this._audioPositionStreamUseCase,
    this._trackActivityUseCase,
  ) : super(PremiumArticleAudioState.notInitialized());

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  late MediaItemArticle _article;
  late String? _imageUrl;
  late bool _isArticleListened;

  StreamSubscription? _playbackStateSubscription;
  StreamSubscription? _audioProgressSubscription;

  @override
  Future<void> close() async {
    await _playbackStateSubscription?.cancel();
    await _audioProgressSubscription?.cancel();
    await _stopAudioUseCase();
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

    _isArticleListened = false;
    _audioProgressSubscription = _audioPositionStreamUseCase().listen((event) {
      if (event.position.inSeconds / event.totalDuration.inSeconds > 0.9 && !_isArticleListened) {
        _isArticleListened = true;
        _trackActivityUseCase.trackEvent(AnalyticsEvent.listenedToArticleAudio(_article.id));
      }
    });
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
