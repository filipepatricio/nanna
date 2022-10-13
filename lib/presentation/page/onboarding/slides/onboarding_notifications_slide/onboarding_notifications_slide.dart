import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
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
    final snackbarController = useMemoized(() => SnackbarController());

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
          snackbarController: snackbarController,
        ),
      ),
    );
  }
}

class _IdleContent extends StatelessWidget {
  const _IdleContent({
    required this.notificationGroups,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final List<NotificationPreferencesGroup> notificationGroups;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: AppDimens.safeTopPadding(context)),
        const Spacer(flex: 5),
        NotificationHeaderContainer(
          startWidget: Text(
            LocaleKeys.onboarding_headerSlideThree.tr(),
            style: AppTypography.h4Bold.copyWith(color: AppColors.textGrey),
          ),
          trailingChildren: [
            Text(
              LocaleKeys.onboarding_notifications_push.tr(),
              style: AppTypography.systemText.copyWith(color: AppColors.charcoal),
            ),
            Text(
              LocaleKeys.onboarding_notifications_email.tr(),
              style: AppTypography.systemText.copyWith(color: AppColors.charcoal),
            ),
          ],
        ),
        const Spacer(),
        Expanded(
          flex: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...notificationGroups
                  .map(
                    (group) => group.channels.map(
                      (notification) => _NotificationRow(
                        channel: notification,
                        snackbarController: snackbarController,
                      ),
                    ),
                  )
                  .flattened
                  .expand(
                    (element) => [
                      element,
                      const Spacer(),
                    ],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required this.value,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(AppDimens.l),
      onTap: onPressed,
      child: AnimatedContainer(
        width: AppDimens.customCheckboxSize,
        height: AppDimens.customCheckboxSize,
        decoration: BoxDecoration(
          color: value ? AppColors.charcoal : null,
          borderRadius: const BorderRadius.all(Radius.circular(AppDimens.customCheckboxRadius)),
          border: Border.all(color: value ? AppColors.charcoal : AppColors.textGrey),
        ),
        duration: const Duration(milliseconds: 100),
        child: value
            ? const Icon(
                Icons.check,
                color: AppColors.white,
                size: AppDimens.customCheckboxIconSize,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.channel,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final NotificationChannel channel;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationHeaderContainer(
          startWidget: Text(
            channel.name,
            style: AppTypography.h4Bold,
          ),
          trailingChildren: [
            NotificationSettingSwitch.squareBlack(
              channel: channel,
              notificationType: NotificationType.push,
              snackbarController: snackbarController,
            ),
            NotificationSettingSwitch.squareBlack(
              channel: channel,
              notificationType: NotificationType.email,
              snackbarController: snackbarController,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.s),
        AutoSizeText(
          channel.description,
          style: AppTypography.b2Regular,
        ),
      ],
    );
  }
}
