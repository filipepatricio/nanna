import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/open_subscription_management_screen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

void main() {
  late SettingsSubscriptionPageCubit settingsSubscriptionPageCubit;

  late GetActiveSubscriptionUseCase getActiveSubscriptionUseCase;
  late OpenSubscriptionManagementScreenUseCase openSubscriptionManagementScreenUseCase;

  setUp(() {
    getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    openSubscriptionManagementScreenUseCase = MockOpenSubscriptionManagementScreenUseCase();
    settingsSubscriptionPageCubit = SettingsSubscriptionPageCubit(
      getActiveSubscriptionUseCase,
      openSubscriptionManagementScreenUseCase,
    );
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscription);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscription));
  });

  test('emit [SettingsSubscriptionPageState.init] when instantiated', () {
    expect(settingsSubscriptionPageCubit.state, const SettingsSubscriptionPageState.init());
  });

  test('emit [SettingsSubscriptionPageState.premium] when active subscription is premium via product purchase', () {
    settingsSubscriptionPageCubit.initialize();

    expect(
      settingsSubscriptionPageCubit.stream,
      emitsInOrder([
        SettingsSubscriptionPageState.premium(subscription: TestData.activeSubscription),
      ]),
    );
  });
  test('emit [SettingsSubscriptionPageState.manualPremium] when subscription is active via manual grant', () {
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionManual);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionManual));
    settingsSubscriptionPageCubit.initialize();

    expect(
      settingsSubscriptionPageCubit.stream,
      emitsInOrder([
        SettingsSubscriptionPageState.manualPremium(subscription: TestData.activeSubscriptionManual),
      ]),
    );
  });

  test('emit [SettingsSubscriptionPageState.trial] when subscription is active and in trial period', () {
    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => TestData.activeSubscriptionTrial);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));
    settingsSubscriptionPageCubit.initialize();

    expect(
      settingsSubscriptionPageCubit.stream,
      emitsInOrder([
        SettingsSubscriptionPageState.trial(subscription: TestData.activeSubscriptionTrial),
      ]),
    );
  });
  test('does not emit state when there is a change to no active subscription', () {
    settingsSubscriptionPageCubit.initialize();

    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

    expect(
      settingsSubscriptionPageCubit.stream,
      emitsInOrder([
        SettingsSubscriptionPageState.premium(subscription: TestData.activeSubscription),
      ]),
    );
  });

  test('emits state based on active subscription changes', () {
    settingsSubscriptionPageCubit.initialize();

    when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscriptionTrial));

    expect(
      settingsSubscriptionPageCubit.stream,
      emitsInOrder([
        SettingsSubscriptionPageState.premium(subscription: TestData.activeSubscription),
        SettingsSubscriptionPageState.trial(subscription: TestData.activeSubscriptionTrial),
      ]),
    );
  });
}
