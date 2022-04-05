import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_article_audio_state.dt.freezed.dart';

@freezed
class PremiumArticleAudioState with _$PremiumArticleAudioState {
  @Implements<BuildState>()
  factory PremiumArticleAudioState.notInitialized() = _PremiumArticleAudioStateNotInitialized;

  @Implements<BuildState>()
  factory PremiumArticleAudioState.initializing() = _PremiumArticleAudioStateInitializing;

  @Implements<BuildState>()
  factory PremiumArticleAudioState.initialized() = _PremiumArticleAudioStateInitialized;
}
