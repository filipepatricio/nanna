import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsPage extends HookWidget {
  const SettingsNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsNotificationCubit>();
    final state = useCubitBuilder<SettingsNotificationCubit, SettingsNotificationsState>(cubit);
    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          LocaleKeys.settings_settings.tr(),
          style: AppTypography.subH1Medium,
        ),
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: state.maybeWhen(
          loading: () => const Loader(),
          notificationSettingsLoaded: (data) => SettingsNotificationsBody(
            snackbarController: snackbarController,
            groups: data,
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
