import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:mockito/mockito.dart';

import 'test_data.dart';

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

class FakeGetSubscriptionPlansUseCase extends Fake implements GetSubscriptionPlansUseCase {
  FakeGetSubscriptionPlansUseCase([this.plans]);

  final List<SubscriptionPlan>? plans;

  @override
  Future<SubscriptionPlanGroup> call() async {
    return SubscriptionPlanGroup(
      plans: plans ??
          [
            TestData.subscriptionPlansWithoutTrial.first,
            TestData.subscriptionPlansWithTrial.last,
          ],
    );
  }
}

class FakeGetActiveSubscriptionUseCase extends Fake implements GetActiveSubscriptionUseCase {
  FakeGetActiveSubscriptionUseCase({required this.activeSubscription});
  final ActiveSubscription activeSubscription;
  @override
  Future<ActiveSubscription> call() async {
    return activeSubscription;
  }

  @override
  Stream<ActiveSubscription> get stream => Stream.value(activeSubscription);
}
