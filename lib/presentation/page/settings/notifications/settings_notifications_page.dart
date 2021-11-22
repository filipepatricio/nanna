import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_state.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          LocaleKeys.settings_settings.tr(),
          style: AppTypography.subH1Medium.copyWith(height: 1),
        ),
      ),
      body: state.maybeWhen(
        loading: () => const Loader(),
        notificationSettingsLoaded: (data) => SettingsNotificationsBody(groups: data),
        orElse: () => const SizedBox(),
      ),
    );
  }
}
