import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsAccountPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsAccountCubit>();
    final state = useCubitBuilder<SettingsAccountCubit, SettingsAccountState>(cubit);

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
          text: LocaleKeys.settings_settings.tr(),
        ),
        title: LocaleKeys.settings_account.tr(),
      ),
      body: SnackbarParentView(
        audioPlayerResponsive: true,
        child: state.maybeMap(
          loading: (_) => const Loader(),
          idle: (data) => SettingsAccountBody(
            cubit: cubit,
            state: state,
            modifiedData: data.data,
            originalData: data.original,
          ),
          updating: (data) => SettingsAccountBody(
            cubit: cubit,
            state: state,
            modifiedData: data.data,
            originalData: data.original,
          ),
          error: (value) => Center(
            child: ErrorView.general(
              retryCallback: cubit.initialize,
            ),
          ),
          offline: (value) => Center(
            child: ErrorView.offline(
              retryCallback: cubit.initialize,
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
