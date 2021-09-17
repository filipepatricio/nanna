import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/setting_switch/notification_setting_switch_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NotificationSettingSwitch extends HookWidget {
  final NotificationChannel channel;

  const NotificationSettingSwitch({
    required this.channel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<NotificationSettingSwitchCubit>();
    final state = useCubitBuilder(cubit);
    final key = useMemoized(() => GlobalKey());

    useEffect(
      () {
        cubit.initialize(channel);
      },
      [cubit],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: state.maybeMap(
        notInitialized: (_) => const _NotInitialized(),
        processing: (state) => _Processing(
          name: state.name,
          value: state.value,
          switchKey: key,
        ),
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
  final String name;
  final bool value;
  final Key switchKey;

  const _Processing({
    required this.name,
    required this.value,
    required this.switchKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTypography.h4Medium,
          ),
        ),
        const SizedBox(width: AppDimens.s),
        CupertinoSwitch(
          key: switchKey,
          onChanged: null,
          value: value,
        ),
      ],
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
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTypography.h4Medium,
          ),
        ),
        const SizedBox(width: AppDimens.s),
        CupertinoSwitch(
          key: switchKey,
          onChanged: onChange,
          value: value,
        ),
      ],
    );
  }
}
