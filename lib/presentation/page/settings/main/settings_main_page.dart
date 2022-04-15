import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsMainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsMainCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          LocaleKeys.settings_settings.tr(),
          style: AppTypography.h3bold,
        ),
        centerTitle: true,
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: AudioPlayerBannerWrapper(
          layout: AudioPlayerBannerLayout.column,
          child: state.maybeWhen(
            init: () => SettingsMainBody(
              cubit: cubit,
              snackbarController: snackbarController,
            ),
            loading: () => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }
}
