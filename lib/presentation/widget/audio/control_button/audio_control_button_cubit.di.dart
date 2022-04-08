import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/pause_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/play_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
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
  );

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  MediaItemArticle? _article;
  String? _imageUrl;

  void configure({MediaItemArticle? article, String? imageUrl}) {
    _article = article;
    _imageUrl = imageUrl;
  }

  @override
  AudioControlButtonCubit create() {
    final article = _article;
    AudioControlButtonCubit cubit;

    if (article == null) {
      cubit = _CurrentlyPlayingAudioCubit(
        _prepareAudioTrackUseCase,
        _playAudioUseCase,
        _pauseAudioUseCase,
        _audioPlaybackStateStreamUseCase,
        _trackActivityUseCase,
      );
    } else {
      cubit = _SelectedArticleCubit(
        _prepareAudioTrackUseCase,
        _playAudioUseCase,
        _pauseAudioUseCase,
        _audioPlaybackStateStreamUseCase,
        _trackActivityUseCase,
        article,
        _imageUrl,
      );
    }

    return cubit;
  }
}

abstract class AudioControlButtonCubit extends Cubit<AudioControlButtonState> {
  AudioControlButtonCubit(
    this._prepareAudioTrackUseCase,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._trackActivityUseCase,
  ) : super(AudioControlButtonState.loading());

  final PrepareArticleAudioTrackUseCase _prepareAudioTrackUseCase;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  StreamSubscription? _audioPlaybackSubscription;

  Future<void> initialize();

  Future<void> play();

  Future<void> pause();

  @override
  Future<void> close() async {
    await _audioPlaybackSubscription?.cancel();
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
  ) : super(
          prepareAudioTrackUseCase,
          playAudioUseCase,
          pauseAudioUseCase,
          audioPlaybackStateStreamUseCase,
          trackActivityUseCase,
        );

  @override
  Future<void> initialize() async {
    await _audioPlaybackSubscription?.cancel();
    _audioPlaybackSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      final state = event.map(
        notInitialized: (_) => AudioControlButtonState.notInitilized(),
        loading: (_) => AudioControlButtonState.loading(),
        playing: (event) => AudioControlButtonState.playing(audioItem: event.audioItem),
        paused: (event) => AudioControlButtonState.paused(audioItem: event.audioItem),
        completed: (event) => AudioControlButtonState.paused(audioItem: event.audioItem),
      );
      emit(state);
    });
  }

  @override
  Future<void> pause() async {
    await state.maybeMap(
      playing: (state) async {
        await _pauseAudioUseCase();
        _trackActivityUseCase.trackEvent(
          AnalyticsEvent.pausedArticleAudio(
            state.audioItem.id,
          ),
        );
      },
      orElse: () {
        Fimber.w('Can not pause audio in this state: ${state.toString()}');
      },
    );
  }

  @override
  Future<void> play() async {
    await state.maybeMap(
      paused: (state) async {
        await _playAudioUseCase();
        _trackActivityUseCase.trackEvent(
          AnalyticsEvent.playedArticleAudio(
            state.audioItem.id,
          ),
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
    this._article,
    this._imageUrl,
  ) : super(
          prepareAudioTrackUseCase,
          playAudioUseCase,
          pauseAudioUseCase,
          audioPlaybackStateStreamUseCase,
          trackActivityUseCase,
        );

  final MediaItemArticle _article;
  final String? _imageUrl;

  @override
  Future<void> initialize() async {
    await _audioPlaybackSubscription?.cancel();
    _audioPlaybackSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      final state = event.map(
        notInitialized: (_) => AudioControlButtonState.notInitilized(),
        loading: (_) => AudioControlButtonState.loading(),
        playing: (event) => _handlePlayingState(event.audioItem),
        paused: (event) => _handlePausedState(event.audioItem),
        completed: (event) => _handleCompletedState(event.audioItem),
      );
      emit(state);
    });
  }

  @override
  Future<void> pause() async {
    await _pauseAudioUseCase();
    _trackActivityUseCase.trackEvent(AnalyticsEvent.pausedArticleAudio(_article.id));
  }

  @override
  Future<void> play() async {
    await state.mapOrNull(
      notInitilized: (state) => _prepareNewAudio(),
      inDifferentAudio: (state) => _prepareNewAudio(),
      paused: (_) => _playAudioUseCase(),
    );
    _trackActivityUseCase.trackEvent(AnalyticsEvent.playedArticleAudio(_article.id));
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
      return AudioControlButtonState.inDifferentAudio();
    }
  }

  AudioControlButtonState _handlePausedState(AudioItem audioItem) {
    if (audioItem.id == _article.id) {
      return AudioControlButtonState.paused(audioItem: audioItem);
    } else {
      return AudioControlButtonState.inDifferentAudio();
    }
  }

  AudioControlButtonState _handleCompletedState(AudioItem audioItem) {
    if (audioItem.id == _article.id) {
      return AudioControlButtonState.paused(audioItem: audioItem);
    } else {
      return AudioControlButtonState.inDifferentAudio();
    }
  }
}
