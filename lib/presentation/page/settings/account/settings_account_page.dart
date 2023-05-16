import 'package:auto_route/auto_route.dart';
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
    final l10n = context.l10n;
    final cubit = useCubit<SettingsAccountCubit>();
    final state = useCubitBuilder<SettingsAccountCubit, SettingsAccountState>(cubit);

    useEffect(
      () {
        cubit.initialize(l10n);
      },
      [cubit],
    );

    return Scaffold(
      appBar: InformedAppBar(
        isConnected: context.watch<IsConnected>(),
        leading: BackTextButton(
          text: context.l10n.settings_settings,
        ),
        title: context.l10n.settings_account,
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
            child: ErrorView(
              retryCallback: () => cubit.initialize(context.l10n),
            ),
          ),
          offline: (value) => Center(
            child: ErrorView.offline(
              retryCallback: () => cubit.initialize(context.l10n),
            ),
          ),
          guest: (value) => Center(
            child: ErrorView.guest(
              retryCallback: () => context.pushRoute(const SignInPageModal()),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
