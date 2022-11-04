import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_body.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_cupertino_app_bar.dart';
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
    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: InformedCupertinoAppBar(
        backLabel: LocaleKeys.settings_settings.tr(),
        title: LocaleKeys.settings_manageMyInterestsTitle.tr(),
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: state.maybeWhen(
          loading: () => const Loader(),
          myInterestsSettingsLoaded: (categoryPreferences) => SettingsManageMyInterestsBody(
            snackbarController: snackbarController,
            categoryPreferences: categoryPreferences,
            cubit: cubit,
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
