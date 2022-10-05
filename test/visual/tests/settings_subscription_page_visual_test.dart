import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_state.dt.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${SettingsSubscriptionPage}_(trial)', (tester) async {
    await withClock(Clock.fixed(DateTime(2022, 09, 27)), () async {
      await tester.startApp(
        initialRoute: const ProfileTabGroupRouter(
          children: [
            SettingsSubscriptionPageRoute(),
          ],
        ),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<SettingsSubscriptionPageCubit>(
            () => FakeSettingsSubscriptionPageCubit(
              SettingsSubscriptionPageState.trial(
                subscription: TestData.activeSubscriptionTrial,
              ),
            ),
          );
        },
      );
      await tester.matchGoldenFile();
    });
  });

  visualTest('${SettingsSubscriptionPage}_(no_trial)', (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsSubscriptionPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<SettingsSubscriptionPageCubit>(
          () => FakeSettingsSubscriptionPageCubit(
            SettingsSubscriptionPageState.premium(
              subscription: TestData.activeSubscription,
            ),
          ),
        );
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsSubscriptionPage}_(manual)', (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsSubscriptionPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<SettingsSubscriptionPageCubit>(
          () => FakeSettingsSubscriptionPageCubit(
            SettingsSubscriptionPageState.manualPremium(
              subscription: TestData.activeSubscriptionManual,
            ),
          ),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}

class FakeSettingsSubscriptionPageCubit extends Fake implements SettingsSubscriptionPageCubit {
  FakeSettingsSubscriptionPageCubit(this._state);

  final SettingsSubscriptionPageState _state;

  @override
  SettingsSubscriptionPageState get state => _state;

  @override
  Stream<SettingsSubscriptionPageState> get stream => Stream.value(_state);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> close() async {}
}
