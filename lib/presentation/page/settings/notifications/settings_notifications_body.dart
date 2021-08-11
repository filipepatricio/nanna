import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_switch_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsNotificationsBody extends HookWidget {
  final SettingsNotificationCubit cubit;
  final SettingsNotificationsData data;

  const SettingsNotificationsBody({required this.cubit, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          LocaleKeys.settings_settingsOverview.tr(),
          style: AppTypography.subH1Medium,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
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
            Text(
              LocaleKeys.settings_newsUpdates.tr(),
              style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
            ),
            const SizedBox(height: AppDimens.s),
            SettingsSwitchItem(
              label: LocaleKeys.settings_newDailyBrief.tr(),
              switchValue: data.dailyBrief,
              onSwitch: (value) {
                cubit.onDailyBriefChange(value);
              },
            ),
            const SizedBox(height: AppDimens.l),
            SettingsSwitchItem(
              label: LocaleKeys.settings_incomingNewTopic.tr(),
              switchValue: data.incomingNewTopic,
              onSwitch: (value) {
                cubit.onIncomingNewTopicChange(value);
              },
            ),
            const SizedBox(height: AppDimens.c),
            Text(
              LocaleKeys.settings_productUpdates.tr(),
              style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
            ),
            const SizedBox(height: AppDimens.s),
            SettingsSwitchItem(
              label: LocaleKeys.settings_newFeatures.tr(),
              switchValue: data.newFeatures,
              onSwitch: (value) {
                cubit.onNewFeaturesChange(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
