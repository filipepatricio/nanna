import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_article_audio_view_state.dt.freezed.dart';

@freezed
class PremiumArticleAudioViewState with _$PremiumArticleAudioViewState {
  @Implements<BuildState>()
  factory PremiumArticleAudioViewState.notInitialized() = _PremiumArticleAudioViewStateNotInitialized;

  @Implements<BuildState>()
  factory PremiumArticleAudioViewState.initializing() = _PremiumArticleAudioViewStateInitializing;

  @Implements<BuildState>()
  factory PremiumArticleAudioViewState.initialized() = _PremiumArticleAudioViewStateInitialized;
}
