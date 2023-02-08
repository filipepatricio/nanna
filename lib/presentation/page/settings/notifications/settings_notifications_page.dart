import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsPage extends HookWidget {
  const SettingsNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsNotificationCubit>();
    final state = useCubitBuilder<SettingsNotificationCubit, SettingsNotificationsState>(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useOnAppLifecycleStateChange(
      (previous, current) {
        if (current == AppLifecycleState.resumed) {
          cubit.initialize();
        }
      },
    );

    return Scaffold(
      appBar: InformedAppBar(
        isConnected: context.watch<IsConnected>(),
        leading: BackTextButton(
          text: LocaleKeys.settings_settings.tr(),
        ),
        title: LocaleKeys.settings_notifications_title.tr(),
      ),
      body: SnackbarParentView(
        audioPlayerResponsive: true,
        child: state.maybeWhen(
          loading: () => const Loader(),
          noPermission: (data) => SettingsNotificationsBody(
            groups: data,
            onRequestPermissionTap: cubit.requestPermission,
          ),
          notificationSettingsLoaded: (data) => SettingsNotificationsBody(groups: data),
          error: () => Center(
            child: ErrorView.general(
              retryCallback: cubit.initialize,
            ),
          ),
          offline: () => Center(
            child: ErrorView.offline(
              retryCallback: cubit.initialize,
            ),
          ),
          orElse: SizedBox.shrink,
        ),
      ),
    );
  }
}
