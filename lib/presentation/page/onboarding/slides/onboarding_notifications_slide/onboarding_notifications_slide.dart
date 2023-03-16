import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_notifications_slide/cubit/onboarding_notifications_slide_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_header_container.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OnboardingNotificationsSlide extends HookWidget {
  const OnboardingNotificationsSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OnboardingNotificationsSlideCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.init();
      },
      [cubit],
    );

    return state.maybeMap(
      orElse: () => const Loader(),
      idle: (idleState) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: _IdleContent(
          notificationGroups: idleState.preferences.groups,
        ),
      ),
    );
  }
}

class _IdleContent extends StatelessWidget {
  const _IdleContent({
    required this.notificationGroups,
    Key? key,
  }) : super(key: key);

  final List<NotificationPreferencesGroup> notificationGroups;

  @override
  Widget build(BuildContext context) {
    return SnackbarParentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppDimens.safeTopPadding(context)),
          const Spacer(flex: 5),
          NotificationHeaderContainer(
            startWidget: Text(
              context.l10n.onboarding_headerSlideNotifications,
              style: AppTypography.b3Medium.copyWith(color: AppColors.of(context).textSecondary),
            ),
            trailingChildren: [
              Text(
                context.l10n.onboarding_notifications_push,
                style: AppTypography.b3Medium,
              ),
              Text(
                context.l10n.onboarding_notifications_email,
                style: AppTypography.b3Medium,
              ),
            ],
          ),
          const Spacer(),
          Expanded(
            flex: 50,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...notificationGroups
                      .map(
                        (group) => group.channels.map(
                          (notification) => _NotificationRow(
                            channel: notification,
                          ),
                        ),
                      )
                      .flattened
                      .expand(
                        (element) => [
                          element,
                          const SizedBox(height: AppDimens.l),
                        ],
                      ),
                  if (kIsAppleDevice) ...[
                    Text(
                      context.l10n.onboarding_tracking_title,
                      style: AppTypography.b2Medium,
                    ),
                    const SizedBox(height: AppDimens.s),
                    Text(
                      context.l10n.onboarding_tracking_info,
                      style: AppTypography.b2Regular.copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.channel,
    Key? key,
  }) : super(key: key);

  final NotificationChannel channel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationHeaderContainer(
          startWidget: Text(
            channel.name,
            style: AppTypography.b2Medium,
          ),
          trailingChildren: [
            NotificationSettingSwitch.squareBlack(
              channel: channel,
              notificationType: NotificationType.push,
              requiresPermission: false,
            ),
            NotificationSettingSwitch.squareBlack(
              channel: channel,
              notificationType: NotificationType.email,
              requiresPermission: false,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.s),
        Text(
          channel.description,
          style: AppTypography.b2Regular.copyWith(
            color: AppColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}
