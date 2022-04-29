import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/show_pills_on_explore_page_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dt.dart';
import 'package:mockito/mockito.dart';

class FakeAppUpdateCheckerCubit extends Fake implements AppUpdateCheckerCubit {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> shouldUpdate() async => true;

  @override
  AppUpdateCheckerState get state => const AppUpdateCheckerState.needsUpdate('2.0.0');

  @override
  Stream<AppUpdateCheckerState> get stream => Stream.value(
        const AppUpdateCheckerState.needsUpdate(
          '2.0.0',
        ),
      );

  @override
  Future<void> close() async {}
}

class FakeAudioPlayerBannerCubit extends Fake implements AudioPlayerBannerCubit {
  @override
  Future<void> initialize() async {}

  @override
  AudioPlayerBannerState get state => AudioPlayerBannerState.visible(
        AudioItem(
          id: '000',
          author: 'Cool author',
          imageUrl: 'www.url.com',
          slug: 'cool-audio',
          title: 'Cool audio title',
        ),
      );

  @override
  Stream<AudioPlayerBannerState> get stream => Stream.value(state);

  @override
  Future<void> close() async {}
}

class FakeTopicCoverCubit extends Fake implements TopicCoverCubit {
  @override
  Future<void> initialize() async {}

  @override
  TopicCoverState get state => TopicCoverState.idle(showPhoto: true);

  @override
  Stream<TopicCoverState> get stream => Stream.value(state);

  @override
  Future<void> close() async {}
}

class FakeShowPillsOnExplorePageUseCase extends Fake implements ShowPillsOnExplorePageUseCase {
  @override
  Future<bool> call() async {
    return true;
  }
}
