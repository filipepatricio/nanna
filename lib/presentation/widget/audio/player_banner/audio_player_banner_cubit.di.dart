import 'dart:async';

import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_file_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_header_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_audio_position_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/stop_audio_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AudioPlayerBannerCubit extends Cubit<AudioPlayerBannerState> {
  AudioPlayerBannerCubit(
    this._audioPlaybackStateStreamUseCase,
    this._stopAudioUseCase,
    this._trackArticleAudioPositionUseCase,
    this._audioPositionStreamUseCase,
    this._getArticleHeaderUseCase,
    this._getArticleAudioFileUseCase,
  ) : super(AudioPlayerBannerState.notInitialized());

  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final TrackArticleAudioPositionUseCase _trackArticleAudioPositionUseCase;
  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final GetArticleHeaderUseCase _getArticleHeaderUseCase;
  final GetArticleAudioFileUseCase _getArticleAudioFileUseCase;

  StreamSubscription? _audioStateSubscription;
  StreamSubscription? _audioPositionSubscription;

  Duration? _currentPosition;

  @override
  Future<void> close() async {
    await _audioStateSubscription?.cancel();
    await _audioPositionSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _audioStateSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      event.map(
        notInitialized: (_) => emit(AudioPlayerBannerState.hidden()),
        loading: (_) => emit(AudioPlayerBannerState.hidden()),
        playing: (state) {
          emit(AudioPlayerBannerState.visible(state.audioItem));
          _preloadArticleDetails(state.audioItem);
        },
        paused: (_) => emit(state),
        completed: (_) => stop(),
      );
    });

    _audioPositionSubscription = _audioPositionStreamUseCase().listen((audioPosition) {
      _currentPosition = audioPosition.position;
    });
  }

  Future<void> stop() async {
    final audioItem = state.mapOrNull(visible: (value) => value.audioItem);
    if (audioItem != null && _currentPosition != null) {
      _trackArticleAudioPositionUseCase(
        audioItem.slug,
        _currentPosition!.inSeconds,
        audioItem.duration?.inSeconds,
      );
    }
    await _stopAudioUseCase();
  }

  Future<void> _preloadArticleDetails(AudioItem item) async {
    final articleParts = await Future.wait(
      [
        _getArticleHeaderUseCase(item.slug),
        _getArticleAudioFileUseCase(item.slug),
      ],
    );

    final articleDetails = ArticleAudioDetails(
      articleParts[0] as MediaItemArticle,
      articleParts[1] as AudioFile,
    );

    state.mapOrNull(
      visible: (state) {
        if (state.audioItem.slug == articleDetails.metadata.slug) {
          emit(
            state.copyWith(
              article: articleDetails,
            ),
          );
        }
      },
    );
  }
}

class ArticleAudioDetails {
  ArticleAudioDetails(this.metadata, this.audioFile);

  final MediaItemArticle metadata;
  final AudioFile audioFile;
}
