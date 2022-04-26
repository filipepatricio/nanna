import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(AppUpdateChecker, (tester) async {
    final AppUpdateCheckerCubit cubit = FakeAppUpdateCheckerCubit();

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppUpdateCheckerCubit>(() => cubit);
      },
    );
    await tester.matchGoldenFile();
  });
}
