import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum NotificationSwitchWidgetType { roundedGreen, squareBlack }

extension _NotificationSwitchTypeExtension on NotificationSwitchWidgetType {
  Color get activeColor {
    switch (this) {
      case NotificationSwitchWidgetType.roundedGreen:
        return AppColors.limeGreenDark;
      case NotificationSwitchWidgetType.squareBlack:
        return AppColors.charcoal;
    }
  }

  BoxShape get boxShape {
    switch (this) {
      case NotificationSwitchWidgetType.roundedGreen:
        return BoxShape.circle;
      case NotificationSwitchWidgetType.squareBlack:
        return BoxShape.rectangle;
    }
  }

  BorderRadiusGeometry? get borderRadius {
    switch (this) {
      case NotificationSwitchWidgetType.squareBlack:
        return const BorderRadius.all(Radius.circular(AppDimens.customCheckboxRadius));
      default:
        return null;
    }
  }
}

class NotificationSettingSwitch extends HookWidget {
  const NotificationSettingSwitch({
    required this.channel,
    required this.notificationType,
    required this.type,
    Key? key,
  }) : super(key: key);

  factory NotificationSettingSwitch.roundedGreen({
    required NotificationChannel channel,
    required NotificationType notificationType,
  }) =>
      NotificationSettingSwitch(
        channel: channel,
        notificationType: notificationType,
        type: NotificationSwitchWidgetType.roundedGreen,
      );

  factory NotificationSettingSwitch.squareBlack({
    required NotificationChannel channel,
    required NotificationType notificationType,
  }) =>
      NotificationSettingSwitch(
        channel: channel,
        notificationType: notificationType,
        type: NotificationSwitchWidgetType.squareBlack,
      );

  final NotificationChannel channel;
  final NotificationType notificationType;
  final NotificationSwitchWidgetType type;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<NotificationSettingSwitchCubit>();
    final state = useCubitBuilder(cubit);
    final key = useMemoized(() => GlobalKey());
    final snackbarController = useSnackbarController();

    useEffect(
      () {
        cubit.initialize(channel, notificationType);
      },
      [cubit],
    );

    useCubitListener<NotificationSettingSwitchCubit, NotificationSettingSwitchState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          generalError: (_) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: LocaleKeys.common_error_tryAgainLater.tr(),
                type: SnackbarMessageType.negative,
              ),
            );
          },
        );
      },
    );

    return state.maybeMap(
      notInitialized: (_) => const _NotInitialized(),
      processing: (state) => _Processing(),
      idle: (state) => _Idle(
        type: type,
        name: state.name,
        value: state.value,
        switchKey: key,
        onChange: cubit.changeSetting,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _NotInitialized extends StatelessWidget {
  const _NotInitialized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _Processing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: AppDimens.l,
        width: AppDimens.l,
        padding: const EdgeInsets.all(AppDimens.one),
        child: const Loader(
          strokeWidth: 2.0,
          color: AppColors.dividerGreyLight,
        ),
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.name,
    required this.value,
    required this.switchKey,
    required this.onChange,
    required this.type,
    Key? key,
  }) : super(key: key);
  final String name;
  final bool value;
  final Key switchKey;
  final Function(bool) onChange;
  final NotificationSwitchWidgetType type;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: AppColors.transparent),
      child: GestureDetector(
        onTap: () => onChange(!value),
        child: Center(
          child: Container(
            color: AppColors.transparent,
            padding: const EdgeInsets.all(AppDimens.s),
            child: Container(
              width: AppDimens.l,
              height: AppDimens.l,
              decoration: BoxDecoration(
                shape: type.boxShape,
                borderRadius: type.borderRadius,
                color: value ? type.activeColor : AppColors.transparent,
                border: Border.fromBorderSide(
                  BorderSide(
                    width: 2.0,
                    color: value ? type.activeColor : AppColors.dividerGreyLight,
                  ),
                ),
              ),
              child: Checkbox(
                key: switchKey,
                value: value,
                shape: const CircleBorder(),
                activeColor: type.activeColor,
                visualDensity: VisualDensity.compact,
                onChanged: (value) => onChange(value!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
