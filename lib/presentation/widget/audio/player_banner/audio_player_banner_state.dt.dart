import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_player_banner_state.dt.freezed.dart';

@Freezed(toJson: false)
class AudioPlayerBannerState with _$AudioPlayerBannerState {
  @Implements<BuildState>()
  factory AudioPlayerBannerState.notInitialized() = _AudioPlayerBannerStateNotInitialized;

  @Implements<BuildState>()
  factory AudioPlayerBannerState.visible(
    AudioItem audioItem, [
    ArticleAudioDetails? article,
  ]) = _AudioPlayerBannerStateVisible;

  @Implements<BuildState>()
  factory AudioPlayerBannerState.hidden() = _AudioPlayerBannerStateHidden;

  factory AudioPlayerBannerState.freeArticlesLeft(String message) = _AudioPlayerBannerStateFreeArticlesLeft;
}
