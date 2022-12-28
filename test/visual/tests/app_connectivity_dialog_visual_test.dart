import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(AppConnectivityChecker, (tester) async {
    final AppConnectivityCheckerCubit cubit = FakeAppConnectivityCheckerCubit();

    await tester.startApp(
      initialRoute: const EmptyPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppConnectivityCheckerCubit>(() => cubit);
      },
    );
    await tester.matchGoldenFile();
  });
}
