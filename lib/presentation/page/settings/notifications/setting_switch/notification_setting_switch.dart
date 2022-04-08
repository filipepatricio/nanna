import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_type.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NotificationSettingSwitch extends HookWidget {
  final NotificationChannel channel;
  final NotificationType notificationType;
  final SnackbarController snackbarController;

  const NotificationSettingSwitch({
    required this.channel,
    required this.notificationType,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<NotificationSettingSwitchCubit>();
    final state = useCubitBuilder(cubit);
    final key = useMemoized(() => GlobalKey());

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: state.maybeMap(
        notInitialized: (_) => const _NotInitialized(),
        processing: (state) => _Processing(),
        idle: (state) => _Idle(
          name: state.name,
          value: state.value,
          switchKey: key,
          onChange: cubit.changeSetting,
        ),
        orElse: () => const SizedBox(),
      ),
    );
  }
}

class _NotInitialized extends StatelessWidget {
  const _NotInitialized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class _Processing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.l,
      width: AppDimens.l,
      padding: const EdgeInsets.all(AppDimens.one),
      child: const Loader(
        strokeWidth: 2.0,
        color: AppColors.dividerGreyLight,
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  final String name;
  final bool value;
  final Key switchKey;
  final Function(bool) onChange;

  const _Idle({
    required this.name,
    required this.value,
    required this.switchKey,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: AppColors.transparent),
      child: Container(
        width: AppDimens.l,
        height: AppDimens.l,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? AppColors.limeGreenDark : AppColors.transparent,
          border: Border.fromBorderSide(
            BorderSide(
              width: 2.0,
              color: value ? AppColors.limeGreenDark : AppColors.dividerGreyLight,
            ),
          ),
        ),
        child: Checkbox(
          key: switchKey,
          value: value,
          shape: const CircleBorder(),
          activeColor: AppColors.limeGreenDark,
          visualDensity: VisualDensity.compact,
          onChanged: (value) => onChange(value!),
        ),
      ),
    );
  }
}
