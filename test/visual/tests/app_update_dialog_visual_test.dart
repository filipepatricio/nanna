import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';

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

class FakeAppUpdateCheckerCubit extends Fake implements AppUpdateCheckerCubit {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> shouldUpdate() async => true;

  @override
  AppUpdateCheckerState get state => const AppUpdateCheckerState.needsUpdate('2.0.0');

  @override
  Stream<AppUpdateCheckerState> get stream => Stream.value(
        const AppUpdateCheckerState.needsUpdate(
          '2.0.0',
        ),
      );

  @override
  Future<void> close() async {}
}
