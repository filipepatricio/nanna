import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_header_container.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pageHorizontalMargin,
            vertical: AppDimens.m,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (onRequestPermissionTap != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimens.m),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).backgroundSecondary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.s),
                      ),
                    ),
                    child: ErrorView(
                      title: context.l10n.settings_notifications_noPermissionTitle,
                      content: context.l10n.settings_notifications_noPermissionContent,
                      action: context.l10n.settings_notifications_noPermissionAction,
                      retryCallback: onRequestPermissionTap,
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
                ...groups
                    .asMap()
                    .entries
                    .map(
                      (group) => _NotificationGroup(
                        group: group.value,
                        showNotificationTypeTitle: group.key == 0,
                      ),
                    )
                    .expand(
                      (element) => [element, const SizedBox(height: AppDimens.l)],
                    ),
                Padding(
                  padding: const EdgeInsets.only(right: AppDimens.s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Badges',
                        style: AppTypography.subH1Bold.copyWith(
                          color: AppColors.of(context).textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppDimens.m),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Indicate the number of new items in Today',
                                  style: AppTypography.b2Medium,
                                ),
                                const SizedBox(height: AppDimens.s),
                                Row(
                                  children: [
                                    InformedSvg(
                                      AppVectorGraphics.locker,
                                      color: Theme.of(context).iconTheme.color,
                                      height: AppDimens.s + AppDimens.xxs,
                                    ),
                                    const SizedBox(width: AppDimens.xs),
                                    Text(
                                      'Unlock with Premium',
                                      style: AppTypography.sansTextNanoLausanne
                                          .copyWith(height: 1, color: AppColors.of(context).textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimens.s),
                          Switch.adaptive(
                            // This bool value toggles the switch.
                            value: true,
                            activeColor: AppColors.of(context).switchPrimary,
                            onChanged: null,
                          )
                        ],
                      ),
                    ],
                  ),
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
    required this.showNotificationTypeTitle,
    Key? key,
  }) : super(key: key);
  final NotificationPreferencesGroup group;
  final bool showNotificationTypeTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotificationHeaderContainer(
          startWidget: Text(
            group.name,
            style: AppTypography.subH1Bold.copyWith(
              color: AppColors.of(context).textTertiary,
            ),
          ),
          trailingChildren: [
            if (showNotificationTypeTitle) ...[
              Text(
                context.l10n.settings_push,
                style: AppTypography.b3Regular.copyWith(
                  color: AppColors.of(context).textTertiary,
                ),
              ),
              Text(
                context.l10n.settings_email,
                style: AppTypography.b3Regular.copyWith(
                  color: AppColors.of(context).textTertiary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppDimens.m),
        ...group.channels.map(
          (channel) => _NotificationChannel(channel: channel),
        ),
      ],
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
