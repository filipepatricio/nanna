import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsManageMyInterestsPage extends HookWidget {
  const SettingsManageMyInterestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsManageMyInterestsCubit>();
    final state = useCubitBuilder<SettingsManageMyInterestsCubit, SettingsManageMyInterestsState>(cubit);

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
          text: context.l10n.settings_settings,
        ),
        title: context.l10n.settings_manageMyInterestsTitle,
      ),
      body: SnackbarParentView(
        audioPlayerResponsive: true,
        child: state.maybeWhen(
          loading: () => const Loader(),
          myInterestsSettingsLoaded: (categoryPreferences) => SettingsManageMyInterestsBody(
            categoryPreferences: categoryPreferences,
            cubit: cubit,
          ),
          error: () => Center(
            child: ErrorView(
              retryCallback: cubit.initialize,
            ),
          ),
          offline: () => Center(
            child: ErrorView.offline(
              retryCallback: cubit.initialize,
            ),
          ),
          guest: () => Center(
            child: ErrorView.guest(
              retryCallback: () => context.pushRoute(const SignInPageModal()),
            ),
          ),
          orElse: SizedBox.shrink,
        ),
      ),
    );
  }
}
