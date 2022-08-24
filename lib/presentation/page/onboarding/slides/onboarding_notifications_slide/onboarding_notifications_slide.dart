import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_notifications_slide/cubit/onboarding_notifications_slide_cubit.di.dart';
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

    useMemoized(
      () => cubit.init(),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: AppDimens.xxl),
          _HeaderContainer(
            startWidget: Text(
              tr(LocaleKeys.onboarding_headerSlideThree),
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
          const SizedBox(height: AppDimens.m),
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
                  const SizedBox(height: AppDimens.l),
                ],
              ),
          if (kIsAppleDevice)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.onboarding_tracking_title.tr(),
                  style: AppTypography.h4Bold,
                ),
                const SizedBox(height: AppDimens.s),
                AutoSizeText(
                  LocaleKeys.onboarding_tracking_info.tr(),
                  style: AppTypography.b2Regular,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HeaderContainer extends StatelessWidget {
  const _HeaderContainer({
    required this.startWidget,
    required this.trailingChildren,
    Key? key,
  }) : super(key: key);

  final List<Widget> trailingChildren;
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: startWidget,
        ),
        const SizedBox(width: AppDimens.m),
        _BaseRightRow(children: trailingChildren),
      ],
    );
  }
}

class _BaseRightRow extends StatelessWidget {
  const _BaseRightRow({
    required this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
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
        _HeaderContainer(
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
