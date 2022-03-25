import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_article_audio_view_state.freezed.dart';

@freezed
class PremiumArticleAudioViewState with _$PremiumArticleAudioViewState {
  @Implements<BuildState>()
  factory PremiumArticleAudioViewState.initializing() = _PremiumArticleAudioViewStateInitializing;

  @Implements<BuildState>()
  factory PremiumArticleAudioViewState.playing(Duration duration) = _PremiumArticleAudioViewStatePlaying;

  @Implements<BuildState>()
  factory PremiumArticleAudioViewState.paused(Duration duration) = _PremiumArticleAudioViewStatePaused;
}
