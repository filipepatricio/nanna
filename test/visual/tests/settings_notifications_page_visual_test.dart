import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
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

  visualTest('${SettingsNotificationsPage}_(no_permission)', (tester) async {
    final repository = FakePushNotificationRepository();
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsNotificationsPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<PushNotificationRepository>(() => repository);
      },
    );

    await tester.matchGoldenFile();

    await tester.tap(find.byType(NotificationSettingSwitch).first);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile('settings_notifications_page_(no_permission_snackbar)');
  });
}

class FakeNotificationSettingSwitchCubit extends Fake implements NotificationSettingSwitchCubit {
  @override
  NotificationSettingSwitchState get state => NotificationSettingSwitchState.generalError();

  @override
  Stream<NotificationSettingSwitchState> get stream => Stream.value(NotificationSettingSwitchState.generalError());

  @override
  Future<void> initialize(_, __, ___) async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> changeSetting(bool value) async {}
}

class FakePushNotificationRepository extends Fake implements PushNotificationRepository {
  final pushToken = 'pushToken';

  @override
  Future<RegisteredPushToken> registerToken() async {
    return RegisteredPushToken(token: pushToken, updatedAt: clock.now());
  }

  @override
  Future<String> getCurrentToken() async => pushToken;

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<bool> requestPermission() async => false;

  // @override
  // Future<void> openNotificationsSettings() async {}

  @override
  Future<bool> shouldOpenNotificationsSettings() async => false;

  @override
  Stream<IncomingPush> pushNotificationOpenStream() => const Stream.empty();

  @override
  Future<NotificationPreferences> getNotificationPreferences() async => TestData.notificationPreferences;

  // @override
  // Future<NotificationChannel> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled) async {

  // }

  @override
  void dispose() {}
}
