import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

void main() {
  late SubscriptionCardCubit subscriptionCardCubit;

  late GetActiveSubscriptionUseCase getActiveSubscriptionUseCase;

  setUp(() {
    getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    subscriptionCardCubit = SubscriptionCardCubit(getActiveSubscriptionUseCase);
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscription);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscription));
  });

  test('emit [SubscriptionCardState.loading] when instantiated', () {
    expect(subscriptionCardCubit.state, const SubscriptionCardState.loading());
  });

  test('emit [SubscriptionCardState.premium] when active subscription is premium via product purchase', () {
    subscriptionCardCubit.initialize();

    expect(
      subscriptionCardCubit.stream,
      emitsInOrder([
        const SubscriptionCardState.premium(),
      ]),
    );
  });
  test('emit [SubscriptionCardState.premium] when subscription is active via manual grant', () {
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionManual);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionManual));
    subscriptionCardCubit.initialize();

    expect(
      subscriptionCardCubit.stream,
      emitsInOrder([
        const SubscriptionCardState.premium(),
      ]),
    );
  });

  test('emit [SubscriptionCardState.trial] when subscription is active and in trial period', () {
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));
    subscriptionCardCubit.initialize();

    expect(
      subscriptionCardCubit.stream,
      emitsInOrder([
        SubscriptionCardState.trial(remainingDays: TestData.activeSubscriptionTrial.remainingTrialDays),
      ]),
    );
  });
  test('emit [SubscriptionCardState.free] when there is no active subscription', () {
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));
    subscriptionCardCubit.initialize();

    expect(
      subscriptionCardCubit.stream,
      emitsInOrder([
        const SubscriptionCardState.free(),
      ]),
    );
  });

  test('emits state based on active subscription changes', () {
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => ActiveSubscription.free());
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));
    subscriptionCardCubit.initialize();

    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscription));

    expect(
      subscriptionCardCubit.stream,
      emitsInOrder([
        const SubscriptionCardState.free(),
        const SubscriptionCardState.premium(),
      ]),
    );
  });
}
