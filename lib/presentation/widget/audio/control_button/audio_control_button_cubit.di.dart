import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_audio_position_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/pause_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/play_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/connection_state_aware_cubit_mixin.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioControlButtonCubitFactory implements CubitFactory<AudioControlButtonCubit> {
  AudioControlButtonCubitFactory(
    this._prepareAudioTrackUseCase,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._trackActivityUseCase,
    this._trackArticleAudioPositionUseCase,
    this._audioPositionStreamUseCase,
    this._getArticleAudioProgressUseCase,
    this._isInternetConnectionAvailableUseCase,
  );

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final TrackArticleAudioPositionUseCase _trackArticleAudioPositionUseCase;
  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final GetArticleAudioProgressUseCase _getArticleAudioProgressUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  MediaItemArticle? _article;
  String? _imageUrl;

  void configure({MediaItemArticle? article, String? imageUrl}) {
    _article = article;
    _imageUrl = imageUrl;
  }

  @override
  AudioControlButtonCubit create() {
    if (_article == null) {
      return _CurrentlyPlayingAudioCubit(
        _prepareAudioTrackUseCase,
        _playAudioUseCase,
        _pauseAudioUseCase,
        _audioPlaybackStateStreamUseCase,
        _trackActivityUseCase,
        _trackArticleAudioPositionUseCase,
        _audioPositionStreamUseCase,
        _getArticleAudioProgressUseCase,
        _isInternetConnectionAvailableUseCase,
      );
    }

    return _SelectedArticleCubit(
      _prepareAudioTrackUseCase,
      _playAudioUseCase,
      _pauseAudioUseCase,
      _audioPlaybackStateStreamUseCase,
      _trackActivityUseCase,
      _trackArticleAudioPositionUseCase,
      _audioPositionStreamUseCase,
      _getArticleAudioProgressUseCase,
      _isInternetConnectionAvailableUseCase,
      _article!,
      _imageUrl,
    );
  }
}

abstract class AudioControlButtonCubit extends Cubit<AudioControlButtonState> with ConnectionStateAwareCubitMixin {
  AudioControlButtonCubit(
    this._prepareAudioTrackUseCase,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._trackActivityUseCase,
    this._trackArticleAudioPositionUseCase,
    this._audioPositionStreamUseCase,
    this._getArticleAudioProgressUseCase,
    this._isInternetConnectionAvailableUseCase,
  ) : super(AudioControlButtonState.loading());

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final TrackArticleAudioPositionUseCase _trackArticleAudioPositionUseCase;
  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final GetArticleAudioProgressUseCase _getArticleAudioProgressUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  @override
  IsInternetConnectionAvailableUseCase get isInternetConnectionAvailableUseCase =>
      _isInternetConnectionAvailableUseCase;

  StreamSubscription? _audioPlaybackSubscription;
  StreamSubscription? _audioPositionSubscription;

  var _currentPosition = Duration.zero;

  @override
  Future<void> onOffline(initialData) async {
    state.maybeMap(
      playing: (_) {},
      paused: (_) {},
      orElse: () => emit(AudioControlButtonState.offline()),
    );
  }

  Future<void> initialize() async {
    await initializeConnection(null);

    await _audioPositionSubscription?.cancel();
    _audioPositionSubscription = _audioPositionStreamUseCase().listen((audioPosition) {
      _currentPosition = audioPosition.position;
    });
  }

  Future<void> play([bool force = false]);

  Future<void> pause();

  @override
  Future<void> close() async {
    await _audioPlaybackSubscription?.cancel();
    await _audioPositionSubscription?.cancel();
    return super.close();
  }
}

class _CurrentlyPlayingAudioCubit extends AudioControlButtonCubit {
  _CurrentlyPlayingAudioCubit(
    PrepareArticleAudioTrackUseCase prepareAudioTrackUseCase,
    PlayAudioUseCase playAudioUseCase,
    PauseAudioUseCase pauseAudioUseCase,
    AudioPlaybackStateStreamUseCase audioPlaybackStateStreamUseCase,
    TrackActivityUseCase trackActivityUseCase,
    TrackArticleAudioPositionUseCase trackArticleAudioPositionUseCase,
    AudioPositionStreamUseCase audioPositionStreamUseCase,
    GetArticleAudioProgressUseCase getArticleAudioProgressUseCase,
    IsInternetConnectionAvailableUseCase isInternetConnectionAvailableUseCase,
  ) : super(
          prepareAudioTrackUseCase,
          playAudioUseCase,
          pauseAudioUseCase,
          audioPlaybackStateStreamUseCase,
          trackActivityUseCase,
          trackArticleAudioPositionUseCase,
          audioPositionStreamUseCase,
          getArticleAudioProgressUseCase,
          isInternetConnectionAvailableUseCase,
        );

  @override
  Future<void> onOnline(initialData) async {
    await _audioPlaybackSubscription?.cancel();
    _audioPlaybackSubscription = _audioPlaybackStateStreamUseCase().listen((playbackState) {
      final newButtonState = playbackState.map(
        notInitialized: (_) => AudioControlButtonState.notInitilized(0.0),
        loading: (_) => AudioControlButtonState.loading(),
        playing: (playbackState) => AudioControlButtonState.playing(audioItem: playbackState.audioItem),
        paused: (playbackState) => AudioControlButtonState.paused(audioItem: playbackState.audioItem),
        completed: (playbackState) => AudioControlButtonState.paused(audioItem: playbackState.audioItem),
      );
      emit(newButtonState);
    });
  }

  @override
  Future<void> initialize() async {
    await super.initialize();
  }

  @override
  Future<void> pause() async {
    await state.maybeMap(
      playing: (state) async {
        await _pauseAudioUseCase();
        _trackActivityUseCase.trackEvent(AnalyticsEvent.pausedArticleAudio(state.audioItem.id));
        _trackArticleAudioPositionUseCase(
          state.audioItem.slug,
          _currentPosition.inSeconds,
          state.audioItem.duration?.inSeconds,
        );
      },
      orElse: () {
        Fimber.w('Can not pause audio in this state: ${state.toString()}');
      },
    );
  }

  @override
  Future<void> play([bool force = false]) async {
    await state.maybeMap(
      paused: (state) async {
        await _playAudioUseCase();
        _trackActivityUseCase.trackEvent(AnalyticsEvent.playedArticleAudio(state.audioItem.id));
        _trackArticleAudioPositionUseCase(
          state.audioItem.slug,
          _currentPosition.inSeconds,
          state.audioItem.duration?.inSeconds,
        );
      },
      orElse: () {
        Fimber.w('Can not play audio in this state: ${state.toString()}');
      },
    );
  }
}

class _SelectedArticleCubit extends AudioControlButtonCubit {
  _SelectedArticleCubit(
    PrepareArticleAudioTrackUseCase prepareAudioTrackUseCase,
    PlayAudioUseCase playAudioUseCase,
    PauseAudioUseCase pauseAudioUseCase,
    AudioPlaybackStateStreamUseCase audioPlaybackStateStreamUseCase,
    TrackActivityUseCase trackActivityUseCase,
    TrackArticleAudioPositionUseCase trackArticleAudioPositionUseCase,
    AudioPositionStreamUseCase audioPositionStreamUseCase,
    GetArticleAudioProgressUseCase getArticleAudioProgressUseCase,
    IsInternetConnectionAvailableUseCase isInternetConnectionAvailableUseCase,
    this._article,
    this._imageUrl,
  ) : super(
          prepareAudioTrackUseCase,
          playAudioUseCase,
          pauseAudioUseCase,
          audioPlaybackStateStreamUseCase,
          trackActivityUseCase,
          trackArticleAudioPositionUseCase,
          audioPositionStreamUseCase,
          getArticleAudioProgressUseCase,
          isInternetConnectionAvailableUseCase,
        );

  final MediaItemArticle _article;
  final String? _imageUrl;

  @override
  Future<void> onOnline(initialData) async {
    await _audioPlaybackSubscription?.cancel();
    _audioPlaybackSubscription = _audioPlaybackStateStreamUseCase().listen((playbackState) {
      final newButtonState = playbackState.map(
        notInitialized: (_) => AudioControlButtonState.notInitilized(_getArticleAudioProgressUseCase(_article)),
        loading: (playbackState) => playbackState.audioItem.slug == _article.slug
            ? AudioControlButtonState.loading()
            : AudioControlButtonState.notInitilized(_getArticleAudioProgressUseCase(_article)),
        playing: (playbackState) => _handlePlayingState(playbackState.audioItem),
        paused: (playbackState) => _handlePausedState(playbackState.audioItem),
        completed: (playbackState) => _handleCompletedState(playbackState.audioItem),
      );
      if (!isClosed) {
        emit(newButtonState);
      }
    });
  }

  @override
  Future<void> initialize() async {
    await super.initialize();
  }

  @override
  Future<void> pause() async {
    await _pauseAudioUseCase();
    _trackActivityUseCase.trackEvent(AnalyticsEvent.pausedArticleAudio(_article.id));
    _trackArticleAudioPositionUseCase(_article.slug, _currentPosition.inSeconds);
  }

  @override
  Future<void> play([bool forceNewAudio = false]) async {
    if (_article.availableInSubscription) {
      await state.mapOrNull(
        notInitilized: (state) => _prepareNewAudio(),
        inDifferentAudio: (state) async {
          if (forceNewAudio || state.completed) {
            if (!state.completed) {
              // Tracking current audio position before being replaced by new audio
              _trackArticleAudioPositionUseCase(
                state.currentAudioItem.slug,
                _currentPosition.inSeconds,
                state.currentAudioItem.duration?.inSeconds,
              );
            }
            await _prepareNewAudio();
          } else {
            emit(AudioControlButtonState.showSwitchAudioPopup());
            emit(state);
          }
        },
        paused: (_) => _playAudioUseCase(),
      );
      _trackArticleAudioPositionUseCase(_article.slug, _currentPosition.inSeconds);
      _trackActivityUseCase.trackEvent(AnalyticsEvent.playedArticleAudio(_article.id));
    } else {
      emit(AudioControlButtonState.needsSubscription());
      emit(AudioControlButtonState.notInitilized(_getArticleAudioProgressUseCase(_article)));
    }
  }

  Future<void> _prepareNewAudio() async {
    await _prepareAudioTrackUseCase(
      article: _article,
      imageUrl: _imageUrl,
    );
    await _playAudioUseCase();
  }

  AudioControlButtonState _handlePlayingState(AudioItem audioItem) {
    if (audioItem.id == _article.id) {
      return AudioControlButtonState.playing(audioItem: audioItem);
    } else {
      return AudioControlButtonState.inDifferentAudio(
        currentAudioItem: audioItem,
        completed: false,
        progress: _getArticleAudioProgressUseCase(_article),
      );
    }
  }

  AudioControlButtonState _handlePausedState(AudioItem audioItem) {
    if (audioItem.id == _article.id) {
      return AudioControlButtonState.paused(audioItem: audioItem);
    } else {
      return AudioControlButtonState.inDifferentAudio(
        currentAudioItem: audioItem,
        completed: false,
        progress: _getArticleAudioProgressUseCase(_article),
      );
    }
  }

  AudioControlButtonState _handleCompletedState(AudioItem audioItem) {
    if (audioItem.id == _article.id) {
      return AudioControlButtonState.paused(audioItem: audioItem);
    } else {
      return AudioControlButtonState.inDifferentAudio(
        currentAudioItem: audioItem,
        completed: true,
        progress: _getArticleAudioProgressUseCase(_article),
      );
    }
  }
}
