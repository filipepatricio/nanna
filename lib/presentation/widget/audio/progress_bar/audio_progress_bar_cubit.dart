import 'dart:async';

import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_position.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AudioProgressBarCubit extends Cubit<AudioProgressBarState> {
  AudioProgressBarCubit(
    this._audioPositionStreamUseCase,
    this._audioPositionSeekUseCase,
    this._articleAudioProgressUseCase,
    this._audioPlaybackStateStreamUseCase,
    this._article,
  ) : super(AudioProgressBarState.initial());

  AudioProgressBarCubit.currentAudio(
    this._audioPositionStreamUseCase,
    this._audioPositionSeekUseCase,
    this._articleAudioProgressUseCase,
    this._audioPlaybackStateStreamUseCase,
  )   : _article = null,
        super(AudioProgressBarState.initial());

  final AudioPositionStreamUseCase _audioPositionStreamUseCase;
  final AudioPositionSeekUseCase _audioPositionSeekUseCase;
  final GetArticleAudioProgressUseCase _articleAudioProgressUseCase;
  final AudioPlaybackStateStreamUseCase _audioPlaybackStateStreamUseCase;

  final MediaItemArticle? _article;

  StreamSubscription? _audioProgressSubscription;
  StreamSubscription? _playbackStateSubscription;

  @override
  Future<void> close() async {
    await _audioProgressSubscription?.cancel();
    await _playbackStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize([MediaItemArticle? article]) async {
    final article = _article;

    _playbackStateSubscription = _audioPlaybackStateStreamUseCase().listen((event) {
      event.mapOrNull(
        loading: (_) => emit(AudioProgressBarState.initial()),
      );
    });

    _audioProgressSubscription = _audioPositionStreamUseCase().listen((event) {
      if (article == null) {
        _emitActive(event);
      } else {
        _resolveStateForSpecifiedID(article, event);
      }
    });
  }

  Future<void> seek(Duration position) async {
    await _audioPositionSeekUseCase(position);
  }

  void _resolveStateForSpecifiedID(MediaItemArticle article, AudioPosition event) {
    if (article.id == event.audioItemID) {
      _emitActive(event);
    } else {
      final progress = _articleAudioProgressUseCase(article);
      emit(AudioProgressBarState.inactive(progress));
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

extension AudioProgressBarStateExtension on AudioProgressBarState {
  double get progress {
    return map(
      initial: (_) => 0.0,
      inactive: (state) => 0.0,
      active: (state) => state.progress.inMilliseconds / state.totalDuration.inMilliseconds,
    );
  }

  Color get progressColor {
    return map(
      initial: (_) => AppColors.textPrimary70,
      inactive: (_) => AppColors.textPrimary70,
      active: (_) => AppColors.textPrimary,
    );
  }
}
