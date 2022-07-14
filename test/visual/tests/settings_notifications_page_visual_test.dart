import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsNotificationsPage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsNotificationsPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsNotificationsPage}_(error)', (tester) async {
    final cubit = FakeNotificationSettingSwitchCubit();
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsNotificationsPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<NotificationSettingSwitchCubit>(() => cubit);
      },
    );

    await cubit.changeSetting(true);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}

class FakeNotificationSettingSwitchCubit extends Fake implements NotificationSettingSwitchCubit {
  @override
  NotificationSettingSwitchState get state => NotificationSettingSwitchState.generalError();

  @override
  Stream<NotificationSettingSwitchState> get stream => Stream.value(NotificationSettingSwitchState.generalError());

  @override
  void initialize(_, __) {}

  @override
  Future<void> close() async {}

  @override
  Future<void> changeSetting(bool value) async {}
}
