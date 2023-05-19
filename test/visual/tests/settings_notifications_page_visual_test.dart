import 'package:better_informed_mobile/domain/push_notification/use_case/has_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
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
    final useCase = MockHasNotificationPermissionUseCase();
    when(useCase()).thenAnswer((_) async => false);

    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsNotificationsPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<HasNotificationPermissionUseCase>(() => useCase);
      },
    );

    await tester.matchGoldenFile();

    await tester.tap(find.byType(NotificationSettingSwitch).first);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile('settings_notifications_page_(no_permission_snackbar)');
  });

  visualTest('${SettingsNotificationsPage}_(guest)', (tester) async {
    final isGuestModeUseCase = MockIsGuestModeUseCase();
    when(isGuestModeUseCase.call()).thenAnswer((_) async => true);

    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsNotificationsPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsGuestModeUseCase>(() => isGuestModeUseCase);
      },
    );

    await tester.matchGoldenFile();
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
