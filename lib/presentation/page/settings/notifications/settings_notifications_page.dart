import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsNotificationCubit>();
    final state = useCubitBuilder<SettingsNotificationCubit, SettingsNotificationsState>(cubit);

    return state.maybeWhen(
      loading: () => const Loader(),
      notificationSettingsLoaded: (data) => SettingsNotificationsBody(cubit: cubit, data: data),
      orElse: () => Container(),
    );
  }
}
