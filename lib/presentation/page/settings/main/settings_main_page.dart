import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsMainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsMainCubit>();
    final state = useCubitBuilder<SettingsMainCubit, SettingsMainState>(cubit, buildWhen: _buildWhen);

    useCubitListener(cubit, _handleState);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          LocaleKeys.settings_settings.tr(),
          style: AppTypography.h3Bold,
        ),
        centerTitle: true,
      ),
      body: state.maybeWhen(
        init: () => SettingsMainBody(cubit),
        loading: () => const Loader(),
        orElse: () => Container(),
      ),
    );
  }

  bool _buildWhen(SettingsMainState state) => state is! SettingsMainStateSignOut;

  void _handleState(SettingsMainCubit cubit, SettingsMainState state, BuildContext context) {
    state.maybeWhen(
      signOut: () {
        //TODO: NAVIGATE TO LOGIN SCREEN
      },
      orElse: () {},
    );
  }
}
