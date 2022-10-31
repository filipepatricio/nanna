import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_cupertino_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsMainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsMainCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InformedCupertinoAppBar(
        backLabel: LocaleKeys.profile_title.tr(),
        title: LocaleKeys.settings_settings.tr(),
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: state.maybeWhen(
          idle: (useSubscriptions) => SettingsMainBody(
            cubit: cubit,
            snackbarController: snackbarController,
            useSubscriptions: useSubscriptions,
          ),
          loading: () => const Loader(),
          orElse: Container.new,
        ),
      ),
    );
  }
}
