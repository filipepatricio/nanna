import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsBody extends HookWidget {
  final List<NotificationPreferencesGroup> groups;

  const SettingsNotificationsBody({
    required this.groups,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.l),
          Text(
            LocaleKeys.settings_pushNotifications.tr(),
            style: AppTypography.h3Bold,
          ),
          const SizedBox(height: AppDimens.l),
          ...groups
              .map((e) => _NotificationGroup(group: e, notificationType: NotificationType.push))
              .expand((element) => [element, const SizedBox(height: AppDimens.l)]),
          const SizedBox(height: AppDimens.c),
          Text(
            LocaleKeys.settings_emailNotifications.tr(),
            style: AppTypography.h3Bold,
          ),
          const SizedBox(height: AppDimens.l),
          ...groups
              .map((e) => _NotificationGroup(group: e, notificationType: NotificationType.email))
              .expand((element) => [element, const SizedBox(height: AppDimens.l)]),
        ],
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final NotificationPreferencesGroup group;
  final NotificationType notificationType;

  const _NotificationGroup({
    required this.group,
    required this.notificationType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          group.name,
          style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
        ),
        const SizedBox(height: AppDimens.m),
        ...group.channels.map(
          (e) => NotificationSettingSwitch(
            channel: e,
            notificationType: notificationType,
          ),
        ),
      ],
    );
  }
}
