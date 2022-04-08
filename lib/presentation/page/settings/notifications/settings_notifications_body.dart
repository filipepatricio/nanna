import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsBody extends HookWidget {
  final List<NotificationPreferencesGroup> groups;
  final SnackbarController snackbarController;

  const SettingsNotificationsBody({
    required this.groups,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.l),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: AppDimens.l),
                Row(
                  children: [
                    Text(
                      LocaleKeys.settings_notifications.tr(),
                      style: AppTypography.h4Bold.copyWith(height: 1),
                    ),
                    const Spacer(),
                    Text(
                      LocaleKeys.settings_push.tr(),
                      style: AppTypography.b3Regular.copyWith(height: 1),
                    ),
                    const SizedBox(width: AppDimens.l),
                    Text(
                      LocaleKeys.settings_email.tr(),
                      style: AppTypography.b3Regular.copyWith(height: 1),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.l),
                ...groups
                    .map(
                      (group) => _NotificationGroup(
                        group: group,
                        snackbarController: snackbarController,
                      ),
                    )
                    .expand((element) => [element, const SizedBox(height: AppDimens.l)]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final NotificationPreferencesGroup group;
  final SnackbarController snackbarController;

  const _NotificationGroup({
    required this.group,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            group.name,
            style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
          ),
          const SizedBox(height: AppDimens.m),
          ...group.channels.map(
            (channel) => _NotificationChannel(
              channel: channel,
              snackbarController: snackbarController,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationChannel extends StatelessWidget {
  final NotificationChannel channel;
  final SnackbarController snackbarController;

  const _NotificationChannel({
    required this.channel,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.l),
      child: Row(
        children: [
          Expanded(
            child: Text(
              channel.name,
              style: AppTypography.h4Medium.copyWith(height: 1),
            ),
          ),
          const SizedBox(width: AppDimens.xl),
          NotificationSettingSwitch(
            channel: channel,
            snackbarController: snackbarController,
            notificationType: NotificationType.push,
          ),
          const SizedBox(width: AppDimens.xl),
          NotificationSettingSwitch(
            channel: channel,
            snackbarController: snackbarController,
            notificationType: NotificationType.email,
          ),
        ],
      ),
    );
  }
}
