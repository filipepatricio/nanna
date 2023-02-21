import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsMainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsMainCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: InformedAppBar(
        isConnected: context.watch<IsConnected>(),
        leading: BackTextButton(
          text: context.l10n.profile_title,
        ),
        title: context.l10n.settings_settings,
      ),
      body: SnackbarParentView(
        audioPlayerResponsive: true,
        child: state.maybeWhen(
          idle: (useSubscriptions) => SettingsMainBody(
            cubit: cubit,
            useSubscriptions: useSubscriptions,
          ),
          loading: Loader.new,
          orElse: Container.new,
        ),
      ),
    );
  }
}
