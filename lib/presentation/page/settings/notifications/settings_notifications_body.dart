import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_header_container.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsBody extends HookWidget {
  const SettingsNotificationsBody({
    required this.groups,
    this.onRequestPermissionTap,
    Key? key,
  }) : super(key: key);

  final List<NotificationPreferencesGroup> groups;
  final VoidCallback? onRequestPermissionTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppDimens.l, AppDimens.l, AppDimens.l, AppDimens.s),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (onRequestPermissionTap != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimens.m),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).buttonSecondaryFrame,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.s),
                      ),
                    ),
                    child: GeneralErrorView(
                      title: LocaleKeys.settings_notifications_noPermissionTitle.tr(),
                      content: LocaleKeys.settings_notifications_noPermissionContent.tr(),
                      action: LocaleKeys.settings_notifications_noPermissionAction.tr(),
                      retryCallback: onRequestPermissionTap,
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
                const SizedBox(height: AppDimens.l),
                NotificationHeaderContainer(
                  startWidget: Text(
                    LocaleKeys.settings_notifications_title.tr(),
                    style: AppTypography.h4Bold.copyWith(height: 1),
                  ),
                  trailingChildren: [
                    Text(
                      LocaleKeys.settings_push.tr(),
                      style: AppTypography.b3Regular.copyWith(height: 1),
                    ),
                    Text(
                      LocaleKeys.settings_email.tr(),
                      style: AppTypography.b3Regular.copyWith(height: 1),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.l),
                ...groups
                    .map(
                      (group) => _NotificationGroup(group: group),
                    )
                    .expand(
                      (element) => [element, const SizedBox(height: AppDimens.l)],
                    ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: AudioPlayerBannerPlaceholder(),
        ),
      ],
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  const _NotificationGroup({
    required this.group,
    Key? key,
  }) : super(key: key);
  final NotificationPreferencesGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            group.name,
            style: AppTypography.subH1Bold.copyWith(
              color: AppColors.of(context).textTertiary,
            ),
          ),
          const SizedBox(height: AppDimens.m),
          ...group.channels.map(
            (channel) => _NotificationChannel(channel: channel),
          ),
        ],
      ),
    );
  }
}

class _NotificationChannel extends StatelessWidget {
  const _NotificationChannel({
    required this.channel,
    Key? key,
  }) : super(key: key);
  final NotificationChannel channel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.l),
      child: NotificationHeaderContainer(
        startWidget: Text(
          channel.name,
          style: AppTypography.b2Medium.copyWith(height: 1),
        ),
        trailingChildren: [
          NotificationSettingSwitch.squareBlack(
            channel: channel,
            notificationType: NotificationType.push,
            requiresPermission: true,
          ),
          NotificationSettingSwitch.squareBlack(
            channel: channel,
            notificationType: NotificationType.email,
            requiresPermission: true,
          ),
        ],
      ),
    );
  }
}
