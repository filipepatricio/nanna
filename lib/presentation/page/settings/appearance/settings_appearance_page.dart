import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_main_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsAppearancePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InformedAppBar(
        isConnected: context.watch<IsConnected>(),
        leading: BackTextButton(
          text: LocaleKeys.settings_settings.tr(),
        ),
        title: LocaleKeys.settings_appearance_title.tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
          child: ValueListenableBuilder(
            valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
            builder: (_, mode, child) => Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Text(
                    LocaleKeys.settings_appearance_theme.tr(),
                    style: AppTypography.subH1Bold.copyWith(
                      color: AppColors.of(context).textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.s),
                SettingsMainItem(
                  label: LocaleKeys.settings_appearance_dark.tr(),
                  icon: mode.isDark ? AppVectorGraphics.checkmark : null,
                  iconColor: AppColors.stateBackgroundSuccess,
                  onTap: AdaptiveTheme.of(context).setDark,
                ),
                const SizedBox(height: AppDimens.s),
                SettingsMainItem(
                  label: LocaleKeys.settings_appearance_light.tr(),
                  icon: mode.isLight ? AppVectorGraphics.checkmark : null,
                  iconColor: AppColors.stateBackgroundSuccess,
                  onTap: AdaptiveTheme.of(context).setLight,
                ),
                const SizedBox(height: AppDimens.s),
                SettingsMainItem(
                  label: LocaleKeys.settings_appearance_auto.tr(),
                  icon: mode.isSystem ? AppVectorGraphics.checkmark : null,
                  iconColor: AppColors.stateBackgroundSuccess,
                  onTap: AdaptiveTheme.of(context).setSystem,
                ),
                const Spacer(),
                const AudioPlayerBannerPlaceholder(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
