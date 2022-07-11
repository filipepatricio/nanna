import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsAccountPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsAccountCubit>();
    final state = useCubitBuilder<SettingsAccountCubit, SettingsAccountState>(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          LocaleKeys.settings_settings.tr(),
          style: AppTypography.subH1Medium.copyWith(height: 1),
        ),
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: AudioPlayerBannerWrapper(
          layout: AudioPlayerBannerLayout.column,
          child: state.maybeMap(
            loading: (_) => const Loader(),
            idle: (data) => SettingsAccountBody(
              cubit: cubit,
              state: state,
              modifiedData: data.data,
              originalData: data.original,
              snackbarController: snackbarController,
            ),
            updating: (data) => SettingsAccountBody(
              cubit: cubit,
              state: state,
              modifiedData: data.data,
              originalData: data.original,
              snackbarController: snackbarController,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
