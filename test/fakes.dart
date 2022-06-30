import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dt.dart';
import 'package:mockito/mockito.dart';

class FakeAppConnectivityCheckerCubit extends Fake implements AppConnectivityCheckerCubit {
  @override
  AppConnectivityCheckerState get state => const AppConnectivityCheckerState.notConnected();

  @override
  Stream<AppConnectivityCheckerState> get stream => Stream.value(const AppConnectivityCheckerState.notConnected());

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> checkIsConnected() async => true;

  @override
  Future<void> close() async {}
}

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
          duration: null,
        ),
      );

  @override
  Stream<AudioPlayerBannerState> get stream => Stream.value(state);

  @override
  Future<void> close() async {}
}

class FakeIsTutorialStepSeenUseCase extends Fake implements IsTutorialStepSeenUseCase {
  FakeIsTutorialStepSeenUseCase({required this.isStepSeen});

  final bool isStepSeen;

  @override
  Future<bool> call(TutorialStep tutorialStep) async => isStepSeen;
}
