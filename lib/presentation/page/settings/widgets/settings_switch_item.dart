import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsSwitchItem extends HookWidget {
  final String label;
  final Function(bool value) onSwitch;
  final bool switchValue;

  const SettingsSwitchItem({
    required this.label,
    required this.switchValue,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final switchState = useState(switchValue);
    return Container(
      height: AppDimens.settingsItemHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.h4Medium),
          Switch(
            onChanged: (bool value) {
              onSwitch(value);
              switchState.value = value;
            },
            value: switchState.value,
          ),
        ],
      ),
    );
  }
}
